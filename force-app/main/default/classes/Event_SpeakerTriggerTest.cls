@isTest
public with sharing class Event_SpeakerTriggerTest {
    @isTest
    public static void Event_SpeakerTriggerTest() {
        Event__c testEvt1 = new Event__c(
            Event_Organizer__c = 'a035g000001QBAjAAO',
            Start_DateTime__c = DateTime.newInstance(2021, 9, 16, 12, 0, 0),
            Max_Seats__c = 80,
            Live__c = true
        );
        Event__c testEvt2 = new Event__c(
            Event_Organizer__c = 'a035g000001QBAjAAO',
            Start_DateTime__c = DateTime.newInstance(2021, 9, 16, 12, 0, 0),
            Max_Seats__c = 100,
            Live__c = true
        );
        insert testEvt1;
        insert testEvt2;
        Event__c testEvtR1 = [SELECT id FROM Event__c WHERE Max_Seats__c = 80];
        Event__c testEvtR2 = [SELECT id FROM Event__c WHERE Max_Seats__c = 100];

        Speaker__c testSp = new Speaker__c(Name = 'ddd');
        insert testSp;

        Speaker__c testSp1 = [
            SELECT id
            FROM Speaker__c
            WHERE Name = 'ddd'
            /* a065g00000Bv6oZAAR */
        ];
        Event_Speaker__c testES1 = new Event_Speaker__c(
            Name = 'test11',
            Speaker__c = testSp1.id,
            Event__c = testEvtR1.id
        );
        insert testES1;
        Event_Speaker__c testES2 = new Event_Speaker__c(
            Name = 'test11',
            Speaker__c = testSp1.id,
            Event__c = testEvtR2.id
        );
        insert testES2;
    }
}
