import { LightningElement, api, wire, track } from 'lwc';
import getEventSpeakers from '@salesforce/apex/EventSpeakerListController.getEventSpeakers'
import { NavigationMixin } from 'lightning/navigation';

export default class EventSpeakersComp extends NavigationMixin(LightningElement) {
    @api recordId
    @track eventSpeakerList = []

    @wire(getEventSpeakers, {eventRecordId: '$recordId'})
    retrieveEventSpeakers({error, data}) {
        if (data) {
            console.log('SpeakerListData:: ' + data.length);
            if(data.length > 0){
                this.eventSpeakerList = data;             
            }            
            else if(data.length == 0){
                this.eventSpeakerList = [];                              
            }  
                
        } else if (error) {
            this.eventSpeakerList = [];          
        }
    }

    navigateNext() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event_Speaker__c',
                actionName: 'new'
            },
            state: {
                nooverride: '1',
                defaultFieldValues: "Event__c=" + this.recordId,
                navigationLocation: 'RELATED_LIST'
            }
        });
    }

    navigateToSpeaker(event) {
        this[NavigationMixin.Navigate] ({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                actionName: 'view'
            }
        })
    }
}