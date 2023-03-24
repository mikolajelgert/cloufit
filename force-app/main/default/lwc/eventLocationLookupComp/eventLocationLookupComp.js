import { LightningElement, wire, track } from 'lwc';
import getLocations from '@salesforce/apex/EventLocationSearchController.getLocations';

export default class EventLocationLookupComp extends LightningElement {
    @track locationName = '';
    @track locationList = [];     
    @track locationId; 
    @track isshow = false;
    @track messageResult = false;
    @track isShowResult = true;   
    @track showSearchedValues = false;   
    @wire(getLocations, {locationName:'$locationName'})

    retrieveLocations ({error, data}) {
       this.messageResult = false;

       if (data) {
           console.log('data:: ' + data.length);
           if(data.length > 0 && this.isShowResult){
               this.locationList = data;                 
               this.messageResult = false;
           }            
           else if(data.length == 0){
               this.locationList = [];                
               this.showSearchedValues = false;

               if(this.locationName != '')
                   this.messageResult = true;               
           }  
               
       } else if (error) {
           this.locationId =  '';
           this.locationName =  '';
           this.locationList = [];           
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
        this.locationName = event.target.value;
    }  

    handleParentSelection(event) {        
        this.showSearchedValues = false;
        this.isShowResult = false;
        this.messageResult = false;
        //parentId
        this.locationId =  event.target.dataset.value;
        //parentLabel
        this.locationName =  event.target.dataset.label;      
        console.log('locationId::' + this.locationId);    

        const selectedEvent = new CustomEvent('selected', { detail: this.locationId });
        // event dispatch
        this.dispatchEvent(selectedEvent);    
    }
}