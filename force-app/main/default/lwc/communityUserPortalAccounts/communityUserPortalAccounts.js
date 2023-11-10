import { LightningElement, wire, api } from 'lwc';
import getUserAllAccounts from '@salesforce/apex/CommunityUserAccountsController.getCommunityUserAllAccounts';
import deleteAccountByUserAccess from '@salesforce/apex/CommunityUserAccountsController.deleteAccountByUserAccess';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import Id from '@salesforce/user/Id';

export default class CommunityUserPortalAccounts extends NavigationMixin(LightningElement) {
    @api userId = Id;
    recordsPerPage = 10;
    userAccountsList = [];
    filteredAccounts = [];
    totalRecordCount; 
    pageNumber = 1;
    totalPageCount;
    isPreviousDisabled;
    isNextDisabled;
    refreshTable;

    columns = [{ label: 'Account Name', fieldName: 'Name', type: 'text', sortable: true },
        { label: 'Account Number', fieldName: 'AccountNumber', type: 'text', sortable: true },
        { label: 'SLA', fieldName: 'SLA__c', type: 'text', sortable: true },
        { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: true },
        {
            type: 'button-icon',
            initialWidth: 100,
            typeAttributes:
            {
                iconName: 'utility:preview',
                name: 'preview',
                iconClass: 'slds-icon-text-success'
            }
        },
        {
            type: 'button-icon',
            initialWidth: 100,
            typeAttributes:
            {
                iconName: 'utility:delete',
                name: 'delete',
                iconClass: 'slds-icon-text-error'
            }
        }];

    @wire(getUserAllAccounts, {userId: '$userId'})
    retrieveUserAllAccounts(result) {
        this.refreshTable = result;
        if (result.data) {
            this.userAccountsList = result.data;
            this.handlePageChange();
            this.totalRecordCount = result.data.length;
            this.calculateTotalPageCount();
            this.filterAccountsByComboOption();
        } else if(result.error) {
            this.userAccountsList = result.error;
        }
    }
    
    handleNextPage() {
        if (this.pageNumber < this.totalPageCount) {
            this.pageNumber += 1;
        }
        this.filterAccountsByComboOption();
        this.handlePageChange();
    }

    handlePrevPage() {
        if (this.pageNumber > 1) {
            this.pageNumber -= 1;
        }
        this.filterAccountsByComboOption();
        this.handlePageChange();
    }

    handlePageChange() {
        if (this.pageNumber >= this.totalPageCount) {
            this.isNextDisabled = true;
        } else {
            this.isNextDisabled = false;
        }

        if (this.pageNumber === 1) {
            this.isPreviousDisabled = true;
        } else {
            this.isPreviousDisabled = false;
        }
    }

    handleComboBoxChange(event) {
        this.pageNumber = 1;
        this.recordsPerPage = event.target.value;
        this.calculateTotalPageCount();
        this.handlePageChange();
        this.filterAccountsByComboOption();
    }

    calculateTotalPageCount() {
        this.totalPageCount = this.totalRecordCount < this.recordsPerPage ? 
        1 : Math.ceil((this.totalRecordCount) / this.recordsPerPage);
    }

    filterAccountsByComboOption() {
        this.filteredAccounts = [];
        for (let i = (this.pageNumber - 1) * this.recordsPerPage; i < this.pageNumber * this.recordsPerPage; i++) {
            if (i < this.totalRecordCount) {
                this.filteredAccounts.push(this.userAccountsList[i]);
            }
        }
    }

    get label() {
        let label = 'Show records (' + this.totalRecordCount + ')';
        return label;
    }

    get comboBoxOptions() {
        let options = [];
        for(var i = 10; i < this.totalRecordCount + 10; i += 10) {
             options.push({label: i, value: i});
        }
        return options;
    }

    handleRowAction(event) {
        let rowId = event.detail.row.Id;

        if (event.detail.action.name === 'preview') {
            this.previewAccount(rowId);
            console.log('rowId: ' + rowId);
        } else if (event.detail.action.name === 'delete') {
            deleteAccountByUserAccess({accountId: rowId})
            .then(() => {
                this.showSuccessToast();
                refreshApex(this.refreshTable);
              })
              .catch((error) => {
                this.showFailToast(error);
              });
        }
    }

    previewAccount(recId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    showSuccessToast() {
        const event = new ShowToastEvent({
          label: "Record deleted",
          message: "Account successfully removed",
          variant: "success"
        });
        this.dispatchEvent(event);
    }

    showFailToast(error) {
        const event = new ShowToastEvent({
            label: "Error deleting record",
            message: error.body.message,
            variant: "error"
          });
        this.dispatchEvent(event);
    }
}