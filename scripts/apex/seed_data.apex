/**
 * MASTER SEED DATA: Acme Services Assessment
 * Goal: Create a full business scenario for Engagement__c
 * Run: sf apex run --file scripts/apex/seed_data.apex
 */

// --- CLEANUP ---
// Remove previous test data to keep the demo environment clean
delete [SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM Engagement__c WHERE Name LIKE 'Acme%')];
delete [SELECT Id FROM Event WHERE WhatId IN (SELECT Id FROM Engagement__c WHERE Name LIKE 'Acme%')];
delete [SELECT Id FROM Engagement__c WHERE Name LIKE 'Acme%'];
delete [SELECT Id FROM Opportunity WHERE Name LIKE 'Acme%'];
delete [SELECT Id FROM Contact WHERE LastName = 'Doe'];
delete [SELECT Id FROM Account WHERE Name = 'Acme Corp'];

// --- 1. CORE DATA ---
Account acme = new Account(
    Name = 'Acme Corp', 
    Industry = 'Technology',
    Website = 'https://acme.example.com'
);
insert acme;

Contact john = new Contact(
    FirstName = 'John',
    LastName = 'Doe',
    Email = 'john.doe@acme.example.com',
    AccountId = acme.Id
);
insert john;

Opportunity opp = new Opportunity(
    Name = 'Acme - Global Expansion Plan',
    StageName = 'Prospecting',
    Amount = 85000,
    CloseDate = Date.today().addMonths(3),
    AccountId = acme.Id
);
insert opp;

// --- 2. THE ENGAGEMENT ---
Engagement__c eng = new Engagement__c(
    Name = 'Acme Strategic Consulting v1',
    Account__c = acme.Id,
    Primary_Contact__c = john.Id,
    Related_Opportunity__c = opp.Id,
    Status__c = 'In Progress',
    Start_Date__c = Date.today().addDays(-15),
    // End_Date__c = Date.today().addMonths(2), // Verify if this field exists in your org
    Budget__c = 25000
);
insert eng;

// --- 3. ACTIVITIES (For LWC Counters) ---
List<Task> demoTasks = new List<Task>();
// 2 Completed Tasks
for(Integer i=1; i<=2; i++) {
    demoTasks.add(new Task(
        Subject = 'Initial Discovery Call ' + i,
        Status = 'Completed',
        Priority = 'Normal',
        WhatId = eng.Id,
        ActivityDate = Date.today().addDays(-i)
    ));
}
// 1 Open Task
demoTasks.add(new Task(
    Subject = 'Review Project Timeline',
    Status = 'Not Started',
    Priority = 'High',
    WhatId = eng.Id,
    ActivityDate = Date.today().addDays(5)
));
insert demoTasks;

// 1 Upcoming Event
Event kickoff = new Event(
    Subject = 'Strategic Alignment Workshop',
    StartDateTime = DateTime.now().addDays(2).addHours(1),
    EndDateTime = DateTime.now().addDays(2).addHours(3),
    WhatId = eng.Id,
    Description = 'Key workshop to align with executive stakeholders.'
);
insert kickoff;

System.debug('>>> SUCCESS: Acme Seed Data Deployed.');
System.debug('>>> View Engagement here: /' + eng.Id);
