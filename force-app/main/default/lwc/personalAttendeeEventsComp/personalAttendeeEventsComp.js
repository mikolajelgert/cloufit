import { LightningElement, track, wire, api } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/PersonalAttendeeEventsController.getUpcomingEvents';
import getPastEvents from '@salesforce/apex/PersonalAttendeeEventsController.getPastEvents';

export default class PersonalAttendeeEventsComp extends LightningElement {

    @api recordId
    activeSections = ['Upcoming Events', 'Past Events']

    @track upcomingEventsList = []
    @track upcomingEventsColumns = [{
        label: 'Event Name',
        fieldName: 'eventIdForURL',
        type: 'url',
        typeAttributes: { 
            label: { fieldName: 'Name__c' }, 
            target: '_blank' 
        },
        sortable: true
    },
    {
        label: 'Event Organizer',
        fieldName: 'Event_Organizer__c',//
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:event' }
    },
    {
        label: 'Event Date',
        fieldName: 'Start_Date_Time__c',//
        type: 'date',
        sortable: true,
    },
    {
        label: 'Location',
        fieldName: 'Location__c',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:location' }
    }];

    @wire(getUpcomingEvents, {attendeeRecordId: '$recordId'})
    retrieveUpcomingEvents({error, data}) {
        if (data) {
            console.log('UpcomingEventsData:: ' + data.length);
            if(data.length > 0){
                this.upcomingEventsList = data;
                if(this.upcomingEventsList) {
                    let preparedEvents = [];
                    this.upcomingEventsList.forEach(eventAttendee => {
                        let preparedEvent = {};
                        preparedEvent.Name__c = eventAttendee.Event__r.Name__c
                        preparedEvent.eventIdForURL = '/' + eventAttendee.Event__r.Id
                        preparedEvent.Event_Organizer__c = eventAttendee.Event__r.Event_Organizer__r.Name
                        preparedEvent.Start_Date_Time__c = eventAttendee.Event__r.Start_Date_Time__c
                        preparedEvent.Location__c = eventAttendee.Event__r.Location__r.Name
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

    @track pastEventsList = []
    @track pastEventsColumns = [{
        label: 'Event Name',
        fieldName: 'eventIdForURL',
        type: 'url',
        typeAttributes: { 
            label: { fieldName: 'Name__c' }, 
            target: '_blank' 
        },
        sortable: true
    },
    {
        label: 'Event Organizer',
        fieldName: 'Event_Organizer__c',//
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:event' }
    },
    {
        label: 'Event Date',
        fieldName: 'Start_Date_Time__c',//
        type: 'date',
        sortable: true,
    },
    {
        label: 'Location',
        fieldName: 'Location__c',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:location' }
    }];

    @wire(getPastEvents, {attendeeRecordId: '$recordId'})
    retrievePastEvents({error, data}) {
        if (data) {
            console.log('PastEventsData:: ' + data.length);
            if(data.length > 0){
                this.pastEventsList = data;
                if(this.pastEventsList) {
                    let preparedEvents = [];
                    this.pastEventsList.forEach(eventAttendee => {
                        let preparedEvent = {};
                        preparedEvent.Name__c = eventAttendee.Event__r.Name__c
                        preparedEvent.eventIdForURL = '/' + eventAttendee.Event__r.Id
                        preparedEvent.Event_Organizer__c = eventAttendee.Event__r.Event_Organizer__r.Name
                        preparedEvent.Start_Date_Time__c = eventAttendee.Event__r.Start_Date_Time__c
                        preparedEvent.Location__c = eventAttendee.Event__r.Location__r.Name
                        preparedEvents.push(preparedEvent);
                    });
                    this.pastEventsList = preparedEvents;             
            }            
            else if(data.length == 0){
                this.pastEventsList = [];                              
            }  
                
            } else if (error) {
                this.pastEventsList = [];          
            }
        }
    }
}