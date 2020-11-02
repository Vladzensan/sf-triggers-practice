import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

import ID_FIELD from '@salesforce/schema/Account.Id';
import GENERATE_PDF_FIELD from '@salesforce/schema/Account.Generate_Pdf__c';

const MSG_ERROR = 'Some error occurred while generating PDF file';
const MSG_SUCCESS = 'PDF file successfully generated';

export default class GeneratePdfComponent extends LightningElement {
    @api accountId;
    @track message;


    connectedCallback() {
        this.message = 'Processing your request...';
        this.generatePdfFile();
    }


    generatePdfFile() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.accountId;
        fields[GENERATE_PDF_FIELD.fieldApiName] = true;
        
        const recordInput = { fields };

        updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: MSG_SUCCESS,
                            variant: 'success'
                        })
                    );
                    this.message = MSG_SUCCESS;
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error generating PDF (' + error.body.message + ')',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    this.message = MSG_ERROR;
                });
    }
}