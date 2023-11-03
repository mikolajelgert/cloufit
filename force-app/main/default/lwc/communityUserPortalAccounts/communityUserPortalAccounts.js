import { LightningElement, wire, api } from 'lwc';
import getUserAccountsByLimit from '@salesforce/apex/CommunityUserAccountsController.getCommunityUserAccountsByLimit';
import getUserAllAccounts from '@salesforce/apex/CommunityUserAccountsController.getCommunityUserAllAccounts';
import deleteAccountByUserAccess from '@salesforce/apex/CommunityUserAccountsController.deleteAccountByUserAccess';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class CommunityUserPortalAccounts extends NavigationMixin(LightningElement) {
    @api accountIdToDelete = '';
    @api recordsPerPage = 10;
    userAccountsList = [];
    totalRecordCount; 
    pageNumber = 1;
    totalPageCount;
    @api offset = 0;
    isPreviousDisabled;
    isNextDisabled;
    refreshTable;

    columns = [{
        label: 'Account Name',
        fieldName: 'accountName',
        type: 'text',
        sortable: true
    },
    {
        label: 'Account Number',
        fieldName: 'accountNumber',
        type: 'text',
        sortable: true
    },
    {
        label: 'SLA',
        fieldName: 'accountSLA',
        type: 'text',
        sortable: true
    },
    {
        label: 'Phone',
        fieldName: 'accountPhone',
        type: 'phone',
        sortable: true
    },
    {
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:preview',
            name: 'preview',
            iconClass: 'slds-icon-text-success'
        }
    },
    {
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:delete',
            name: 'delete',
            iconClass: 'slds-icon-text-error'
        }
    }];

    @wire(getUserAllAccounts)
    retreiveUserAllAccounts({data, error}) {
        if (data) {
            this.totalRecordCount = data.length;
        } else if (error) {
            this.totalRecordCount = 0;
        }
    }

    @wire(getUserAccountsByLimit, {recordsLimit: '$recordsPerPage', offset: '$offset'})
    retreiveUserAccountsByLimit(result) {
        this.refreshTable = result;
        if (result.data) {
            if (result.data.length > 0) {
                this.userAccountsList = result.data;
                this.handlePageChange();
            } else {
                this.userAccountsList = [];
            }
        } else if (result.error){
            this.userAccountsList = [];
        }
    }

    handleNextPage() {
        if (this.pageNumber < this.totalPageCount) {
            this.pageNumber += 1;
        }
        this.offset += parseInt(this.recordsPerPage);
        this.handlePageChange();
    }

    handlePrevPage() {
        if (this.pageNumber > 1) {
            this.pageNumber -= 1;
        }
        this.offset -= parseInt(this.recordsPerPage);
        this.handlePageChange();
    }

    handlePageChange() {
        if (this.pageNumber === 1) {
            this.isPreviousDisabled = true;
        } else {
            this.isPreviousDisabled = false;
        }

        if (this.pageNumber >= this.totalPageCount) {
            this.isNextDisabled = true;
        } else {
            this.isNextDisabled = false;
        }
    }

    handleComboBoxChange(event) {
        this.offset = 0;
        this.pageNumber = 1;
        this.recordsPerPage = event.target.value;
    }

    get label() {
        let label = 'Show records (' + this.totalRecordCount + ')';
        return label;
    }

    get comboBoxOptions() {
        this.calculateTotalPageCount();

        let options = [];
        for(var i = 10; i < this.totalRecordCount + 10; i += 10) {
             options.push({label: i, value: i});
        }

        return options;
    }

    calculateTotalPageCount() {
        this.totalPageCount = this.totalRecordCount < this.recordsPerPage ? 
        1 : Math.ceil((this.totalRecordCount) / this.recordsPerPage);
    }

    handleRowAction(event) {
        const rowId = event.detail.row.id;

        if (event.detail.action.name === 'preview') {
            this.previewAccount(rowId);
        } else if (event.detail.action.name === 'delete') {
            this.accountIdToDelete = rowId;
            deleteAccountByUserAccess({accountId: this.accountIdToDelete})
            .then(() => {
                this.showSuccessToast();
                refreshApex(this.refreshTable);
              })
              .catch((error) => {
                this.showFailToast(error);
              });
        }
    }

    previewAccount(rowId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: rowId,
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