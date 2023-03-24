import { LightningElement, wire, track } from 'lwc';
import getEventOrganizers from '@salesforce/apex/EventOrganizerSearchController.getEventOrganizers';

export default class EventOrganizerLookupComp extends LightningElement {
    @track eventOrganizerName = '';
    @track eventOrganizerList = [];     
    @track eventOrganizerId; 
    @track isshow = false;
    @track messageResult = false;
    @track isShowResult = true;   
    @track showSearchedValues = false;   
    @wire(getEventOrganizers, {organizerName:'$eventOrganizerName'})

    retrieveEventOrganizers ({error, data}) {
       this.messageResult = false;

       if (data) {
           // TODO: Error handling 
           console.log('data:: ' + data.length);
           if(data.length > 0 && this.isShowResult){
               this.eventOrganizerList = data;                
               this.messageResult = false;
           }            
           else if(data.length == 0){
               this.eventOrganizerList = [];                
               this.showSearchedValues = false;

               if(this.eventOrganizerName != '')
                   this.messageResult = true;               
           }  
               
       } else if (error) {
           // TODO: Data handling
           this.eventOrganizerId =  '';
           this.eventOrganizerName =  '';
           this.eventOrganizerList = [];           
           this.showSearchedValues = false;
           this.messageResult = true;   
       }
   }

    handleClick(event) {
        this.isShowResult = true;
        this.showSearchedValues = true;    
        this.messageResult = false;        
    }

    handleKeyChange(event) {       
        this.messageResult = false;
        this.eventOrganizerName = event.target.value;
    }  

    handleParentSelection(event) {        
        this.showSearchedValues = false;
        this.isShowResult = false;
        this.messageResult = false;
        //parentId
        this.eventOrganizerId =  event.target.dataset.value;
        //parentLabel
        this.eventOrganizerName =  event.target.dataset.label;      
        console.log('eventOrganizerId::' + this.eventOrganizerId);    

        const selectedEvent = new CustomEvent('selected', { detail: this.eventOrganizerId });
        // event dispatch
        this.dispatchEvent(selectedEvent);    
    }
}