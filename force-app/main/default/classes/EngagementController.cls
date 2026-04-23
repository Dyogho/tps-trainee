public with sharing class EngagementController {

    // Save result un memory web cache
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getEngagementStats(Id engagementId) {
        Map<String, Integer> stats = new Map<String, Integer>();
 
        Integer taskCount = [SELECT COUNT() FROM Task 
                             WHERE WhatId = :engagementId 
                             AND Status = 'Completed'
                             WITH USER_MODE];
        stats.put('completedTasks', taskCount);
 
        Integer eventCount = [SELECT COUNT() FROM Event 
                              WHERE WhatId = :engagementId 
                              AND StartDateTime >= TODAY
                              WITH USER_MODE];
        stats.put('upcomingEvents', eventCount);
 
        return stats;
    }

    @AuraEnabled
    public static void createFollowUpTask(Id engagementId, String engagementName) {
        try {
            Task newTask = new Task(
                Subject = 'Follow-up on ' + (engagementName ?? 'Engagement'),
                Status = 'Not Started',
                Priority = 'Normal',
                ActivityDate = Date.today().addDays(1),
                WhatId = engagementId,
                TaskSubtype = 'Call'
            );
 
            insert as user newTask;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating follow-up task: ' + e.getMessage());
        }
    }
}
