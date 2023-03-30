import { LightningElement, api, wire} from 'lwc';
import getLocationId from '@salesforce/apex/EventLocationDetails.getLocationId'

export default class EventTabSet extends LightningElement {
    @api recordId
    @api objectApiName
}