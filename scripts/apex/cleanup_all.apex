/**
 * NUCLEAR CLEANUP: Acme Services Assessment
 * Goal: Wipe all data created during the assessment to start fresh.
 * Run: sf apex run --file scripts/apex/cleanup_all.apex
 */

System.debug('>>> Starting Nuclear Cleanup...');

// 1. Delete Activities (Tasks & Events) related to Engagements
delete [SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM Engagement__c)];
delete [SELECT Id FROM Event WHERE WhatId IN (SELECT Id FROM Engagement__c)];
System.debug('Activities deleted.');

// 2. Delete Engagements
delete [SELECT Id FROM Engagement__c];
System.debug('Engagements deleted.');

// 3. Delete Opportunities (Filter by Acme to avoid touching standard data if desired)
delete [SELECT Id FROM Opportunity WHERE Name LIKE 'Acme%'];
System.debug('Opportunities deleted.');

// 4. Delete Contacts
delete [SELECT Id FROM Contact WHERE Account.Name LIKE 'Acme%'];
System.debug('Contacts deleted.');

// 5. Delete Accounts
delete [SELECT Id FROM Account WHERE Name LIKE 'Acme%'];
System.debug('Accounts deleted.');

System.debug('>>> SUCCESS: Organization is now clean.');
