import { LightningElement, api } from 'lwc';
import getData from '@salesforce/apex/QDX_FormattedSummaryController.getData'

export default class QdxFormattedSummaryRelatedList extends LightningElement {
    @api recordId;
    @api cardTitle;
    @api relatedSobject;
    @api relatedLookup;
    @api relatedFields;
    @api summaryFormat;
    queryString = '';
    formattedSummaries = [
        {
            id: "1",
            value: "This is value 1"
        }, {
            id: "2",
            value: "This is value 2"
        }, {
            id: "3",
            value: "This is value 3"
        }
    ];

    connectedCallback() {
        this.queryString = 'SELECT ' + this.relatedFields 
            + ' FROM ' + this.relatedSobject 
            + ' WHERE ' + this.relatedLookup + ' = \'' + this.recordId + '\'' 
            + ' ORDER BY CreatedDate DESC';
        getData({ recordId: this.recordId, queryString: this.queryString, summaryFormat: this.summaryFormat})
            .then(result => {
                if (result) {
                    this.formattedSummaries = result;
                }
            });
    }
}