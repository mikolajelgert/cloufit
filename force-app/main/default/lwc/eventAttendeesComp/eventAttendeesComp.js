import { LightningElement, api, wire, track } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import getEventAttendees from '@salesforce/apex/EventAttendeeListController.getEventAttendees'


export default class EventAttendeesComp extends NavigationMixin(LightningElement) {
    @api recordId
    @track eventAttendeesList = []

    @track columns = [{
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true,
        cellAttributes: { iconName: 'standard:avatar' }
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
        sortable: true,
        cellAttributes: { iconName: 'standard:call' }
    },
    {
        label: 'Email',
        fieldName: 'Email',
        type: 'email',
        sortable: true
    },
    {
        label: 'Company',
        fieldName: 'Company',
        type: 'text',
        sortable: true
    },
    {
        label: 'Location',
        fieldName: 'Location',
        type: 'Lookup',
        sortable: true
    }];

    @wire(getEventAttendees, {eventRecordId: '$recordId'})
    retrieveEventAttendees({error, data}) {
        if (data) {
            console.log('AttendeesListData:: ' + data.length);
            if(data.length > 0){
                this.eventAttendeesList = data;             
            }            
            else if(data.length == 0){
                this.eventAttendeesList = [];                              
            }  
                
        } else if (error) {
            this.eventAttendeesList = [];          
        }
    }

    navigateNext() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event_Attendee__c',
                actionName: 'new'
            },
            state: {
                nooverride: '1',
                defaultFieldValues: "Event__c=" + this.recordId,
                navigationLocation: 'RELATED_LIST'
            }
        });
    }
}