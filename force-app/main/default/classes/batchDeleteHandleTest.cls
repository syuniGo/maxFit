@isTest
public with sharing class batchDeleteHandleTest {
    @testSetup
    static void setup() {
        List<Event__c> evts = new List<Event__c>();

        for (Integer i = 0; i < 10; i++) {
            evts.add(
                new Event__c(
                    Event_Organizer__c = 'a035g000001QBAjAAO',
                    End_Date_Time__c = DateTime.newInstance(
                        2020,
                        9,
                        16,
                        12,
                        0,
                        0
                    ),
                    Max_Seats__c = 150,
                    Live__c = true
                )
            );
        }
        insert evts;
        // find the account just inserted. add contact for each
    }
    @isTest
    static void test() {
        Test.startTest();
        batchDeleteHandle devts = new batchDeleteHandle();
        Id batchId = Database.executeBatch(devts);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(
            0,
            [SELECT COUNT() FROM Event__c WHERE Max_Seats__c = 150]
        );
    }
}
