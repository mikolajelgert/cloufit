import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import EVENT_OBJECT from '@salesforce/schema/Event__c'

import NAME_FIELD from '@salesforce/schema/Event__c.Name__c'
import EVENT_ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c' 
import START_DATE_TIME_FIELD from '@salesforce/schema/Event__c.Start_Date_Time__c'
import END_DATE_TIME_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c'
import MAX_SEATS_FIELD from '@salesforce/schema/Event__c.Max_Seats__c'
import EVENT_LOCATION_FIELD from '@salesforce/schema/Event__c.Location__c' 
import EVENT_DETAIL_FIELD from '@salesforce/schema/Event__c.Event_Detail__c'

export default class NewEventRecordComp extends NavigationMixin(LightningElement) {
    @track selectedEventOrganizerId
    @track selectedEventLocationId
    @track eventId

    formFields = {
        Name: '',
        Event_Organizer: '', 
        Start_Date_Time: '',
        End_Date_Time: '',
        Max_Seats: '',
        Event_Location: '', 
        Event_Detail: ''
    }

    changeHandler(event) {
        const {value, name} = event.target
        this.formFields = {...this.formFields, [name]: value}
    }

    handleSave() {
        const fields = {}
        fields[NAME_FIELD.fieldApiName] = this.formFields.Name
        fields[EVENT_ORGANIZER_FIELD.fieldApiName] = this.selectedEventOrganizerId   //lookup
        fields[START_DATE_TIME_FIELD.fieldApiName] = this.formFields.Start_Date_Time
        fields[END_DATE_TIME_FIELD.fieldApiName] = this.formFields.End_Date_Time
        fields[MAX_SEATS_FIELD.fieldApiName] = this.formFields.Max_Seats
        fields[EVENT_LOCATION_FIELD.fieldApiName] = this.selectedEventLocationId   //lookup
        fields[EVENT_DETAIL_FIELD.fieldApiName] = this.formFields.Event_Detail

        const recordInput = {apiName: EVENT_OBJECT.objectApiName, fields}
        createRecord(recordInput)
            .then(eventObj=> {
                this.eventId = eventObj.id
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Event created',
                        variant: 'success',
                    }),
                )
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: eventObj.id,
                        objectApiName: 'Event__c',
                        actionName: 'view'
                    },
                })
            })
            .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error',
                }),
            )
        })
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event__c',
                actionName: 'home'
            }
        });
    }

    handleSelectedEventOrganizer(event) {
        console.log(event.detail)
        this.selectedEventOrganizerId = event.detail
    }

    handleSelectedEventLocation(event) {
        console.log(event.detail)
        this.selectedEventLocationId = event.detail
    }
}