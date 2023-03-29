import { LightningElement, api } from 'lwc';

export default class QdxRenderHtml extends LightningElement {
    @api cardTitle;
    @api cardContent;
}