import { LightningElement, api } from 'lwc';
import getData from '@salesforce/apex/QDX_FormattedSummaryController.getData'

export default class QdxFormattedSummaryRelatedList extends LightningElement {
    @api recordId;
    @api cardTitle;
    @api propertyLabel;
    formattedSummaries = [];

    connectedCallback() {
        
        getData({ recordId: this.recordId, propertyLabel: this.propertyLabel})
            .then(result => {
                if (result) {
                    this.formattedSummaries = result;
                }
            });
    }
}