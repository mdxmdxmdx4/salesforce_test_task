import { LightningElement, wire, track, api } from 'lwc';
import getUserCases from '@salesforce/apex/ServiceCaseQueueService.getUserCases';
import updateCaseStatus from '@salesforce/apex/ServiceCaseQueueService.updateCaseStatus';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import USER_ID from '@salesforce/user/Id';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ServiceCaseQueueFiltered extends NavigationMixin(LightningElement) {
    @track cases;
    @track error;
    @track caseStatusValues = [];
    @api objectInfo;
    wiredCasesResult;

    @wire(getUserCases, { userId: USER_ID })
    wiredCases(result) {
        this.wiredCasesResult = result;
        if (result.data) {
            this.cases = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.cases = undefined;
        }
    }

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.caseStatusValues = data.values.map(item => ({ label: item.label, value: item.value }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.caseStatusValues = undefined;
        }
    }
    

    get caseOptions() {
        return this.caseStatusValues;
    }

    navigateToCasePage(event) {
        event.preventDefault();
        const caseId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: caseId,
				objectApiName: 'Case',
				actionName: 'view',
			},
		});
    }

    handleStatusChange(event) {
        const caseId = event.target.dataset.id;
        const caseStatus = event.target.value;
        updateCaseStatus({ caseId: caseId, status: caseStatus })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case status updated to ' + caseStatus,
                        variant: 'success',
                    }),
                );
                return refreshApex(this.wiredCasesResult);
            })
            .catch(error => {
                console.error('Error updating case status', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating case status',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
    
    refreshTable() {
        return refreshApex(this.wiredCasesResult);
    }

    renderedCallback() {
        this.setCaseStatusValues();
    }

    setCaseStatusValues() {
        const selects = this.template.querySelectorAll('select');
        selects.forEach(select => {
            const caseId = select.dataset.id;
            const caseRecord = this.cases.find(c => c.Id === caseId);
            if (caseRecord) {
                const options = select.querySelectorAll('option');
                options.forEach(option => {
                    if (option.value === caseRecord.Status) {
                        option.setAttribute('selected', '');
                    }
                });
            }
        });
    }
    
}
