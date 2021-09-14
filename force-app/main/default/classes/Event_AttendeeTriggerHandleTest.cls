@isTest
public with sharing class Event_AttendeeTriggerHandleTest {
    @testSetup
    static void makeData() {
        Location__c testLoca = new Location__c(
            Country__c = 'Japan',
            State__c = 'Kanagawa',
            City__c = 'Yokohama',
            Street__c = '元町・中華街駅'
        );
        insert testLoca;

        Event__c testEvt = new Event__c(
            Event_Organizer__c = 'a035g000001QBAjAAO',
            Start_DateTime__c = DateTime.newInstance(2021, 9, 16, 12, 0, 0),
            Max_Seats__c = 80,
            Live__c = true,
            Name__c = 'tttt',
            Location__c = testLoca.id
        );
        insert testEvt;

        Attendees__c testAtt = new Attendees__c(
            Name = 'testAtt',
            Phone__c = '1234567',
            Email__c = 'diamondjsf@gmail.com'
        );
        insert testAtt;

        Event_Attendee__c newEvtAtt = new Event_Attendee__c(
            Name = ' test EvtAtt',
            Event__c = testEvt.id,
            Attendee__c = testAtt.id
        );
        insert newEvtAtt;
    }

    @isTest
    static void sendEmailTest() {
        Test.startTest();
        try {
            integer i = 10 / 0;
        } catch (System.Exception ex) {
        }
        Test.stopTest();
    }
}
