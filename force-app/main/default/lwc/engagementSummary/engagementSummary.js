import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getEngagementStats from '@salesforce/apex/EngagementController.getEngagementStats';
import createFollowUpTask from '@salesforce/apex/EngagementController.createFollowUpTask';

const FIELDS = [
  'Engagement__c.Name',
  'Engagement__c.Related_Opportunity__r.Amount'
];

export default class EngagementSummary extends LightningElement {
  @api recordId;
  engagementName;
  oppAmount;
  stats = { completedTasks: 0, upcomingEvents: 0 };
  wiredStatsResult;

  @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
  wiredEngagement({ error, data }) {
    if (data) {
      this.engagementName = data.fields.Name.value;
      this.oppAmount = data.fields.Related_Opportunity__r.value?.fields.Amount.value || 0;
    }
  }

  @wire(getEngagementStats, { engagementId: '$recordId' })
  wiredStats(result) {
    this.wiredStatsResult = result;
    if (result.data) {
      this.stats = result.data;
    } else if (result.error) {
      console.error('Error fetching stats:', result.error);
    }
  }

  handleRefresh() {
    return refreshApex(this.wiredStatsResult)
      .then(() => {
        this.dispatchEvent(new ShowToastEvent({
          title: 'Success',
          message: 'Stats updated',
          variant: 'success'
        }));
      })
      .catch(error => {
        console.error('Error refreshing stats:', error);
      });
  }

  handleQuickCall() {
    createFollowUpTask({
      engagementId: this.recordId,
      engagementName: this.engagementName
    })
      .then(() => {
        this.dispatchEvent(new ShowToastEvent({
          title: 'Success',
          message: 'Follow-up call scheduled for tomorrow!',
          variant: 'success'
        }));
        return refreshApex(this.wiredStatsResult);
      })
      .catch(error => {
        this.dispatchEvent(new ShowToastEvent({
          title: 'Error creating task',
          message: error.body ? error.body.message : 'Unknown error',
          variant: 'error'
        }));
      });
  }
}

