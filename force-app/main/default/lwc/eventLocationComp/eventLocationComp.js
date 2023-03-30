import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLocationId from '@salesforce/apex/EventLocationDetails.getLocationId'


export default class EventLocationComp extends LightningElement {
    @api recordId
    eventLocationId

    @wire(getLocationId, {eventRecordId: '$recordId'})

    retrieveLocationId({error, data}) {
        if (data) {
            console.log('data:: ' + data.length);
            if(data.length > 0){
                this.eventLocationId = data;                
            }            
            else if(data.length == 0){
                this.eventLocationId = null;          
            }  
                
        } else if (error) {
            console.log('id not retrieved')
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error retrieving location Id',
                    message: error.body.message,
                    variant: 'error',
                }),
            )
        }
    }
    
}