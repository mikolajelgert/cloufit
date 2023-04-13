import { LightningElement, wire, track } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/UpcomingEventsListController.getUpcomingEvents';
 
export default class UpcomingEventsComp extends LightningElement {

    @track nameSearchKey = ''
    @track locationSearchKey = ''
    @track startDateSearchKey = null
    @track upcomingEventsList = []
    @track columns = [{
        label: 'View',
        fieldName: 'eventIdForURL',
        type: 'url',
        typeAttributes: { 
            label: { fieldName: 'Name__c' }, 
            target: '_blank' 
        },
        sortable: true
    },
    {
        label: 'Name',
        fieldName: 'Name__c',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:event' }
    },
    {
        label: 'Event Organizer',
        fieldName: 'Event_Organizer__c',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:avatar' }
    },
    {
        label: 'Location',
        fieldName: 'Location__c',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:location' }
    },
    {
        label: 'Start Date/Time',
        fieldName: 'Start_Date_Time__c',
        type: 'date',
        sortable: true
    }];

    @wire(getUpcomingEvents, {nameTextKey: '$nameSearchKey', locationTextKey: '$locationSearchKey', startDateTextKey: '$startDateSearchKey'})
    retrieveUpcomingEvents({error, data}) {
        if (data) {
            console.log('UpcomingEventsData:: ' + data.length);
            if(data.length > 0){
                this.upcomingEventsList = data;
                if(this.upcomingEventsList) {
                    let preparedEvents = [];
                    this.upcomingEventsList.forEach(event => {
                        let preparedEvent = {};
                        preparedEvent.Name = event.Name
                        preparedEvent.eventIdForURL = '/' + event.Id
                        preparedEvent.Name__c = event.Name__c
                        preparedEvent.Event_Organizer__c = event.Event_Organizer__r.Name
                        preparedEvent.Location__c = event.Location__r.Name
                        preparedEvent.Start_Date_Time__c = event.Start_Date_Time__c
                        preparedEvents.push(preparedEvent);
                    });
                    this.upcomingEventsList = preparedEvents;             
            }            
            else if(data.length == 0){
                this.upcomingEventsList = [];                              
            }  
                
            } else if (error) {
                this.upcomingEventsList = [];          
            }
        }
    }

    handleNameSearchKey(event) {
        this.nameSearchKey = event.target.value
        console.log('searchNameKey: ' + this.nameSearchKey)
    }

    handleLocationSearchKey(event) {
        this.locationSearchKey = event.target.value
        console.log('searchLocationKey: ' + this.locationSearchKey)
    }

    handleStartDateSearchKey(event) {
        this.startDateSearchKey = event.target.value
        console.log('searchStartDateKey: ' + this.startDateSearchKey)
    }

}