public with sharing class Event_SpeakerTriggerHandle {
    public static void Event_SpeakerTriggerHandle(
        List<Event_Speaker__c> newMap
    ) {
        system.debug(newMap.size());
        Set<String> speakerId = new Set<String>();
        Set<String> eventId = new Set<String>();

        for (Event_Speaker__c newES : newMap) {
            speakerId.add(newES.Speaker__c);
            eventId.add(newES.Event__c);
        }
        Map<Id, DateTime> EvtIDwithStartTime = new Map<Id, DateTime>();
        list<Event__c> newEvts = [
            SELECT Start_DateTime__c
            FROM Event__c
            WHERE id IN :eventId
        ];

        for (Event__c newEvt : newEvts) {
            EvtIDwithStartTime.put(newEvt.id, newEvt.Start_DateTime__c);
        }

        list<Event_Speaker__c> esInSpeakers = [
            SELECT speaker__c, event__c, event__r.Start_DateTime__c
            FROM Event_Speaker__c
            WHERE speaker__c IN :speakerId
        ];

        for (Event_Speaker__c triggerNew : newMap) {
            Datetime bookTime = EvtIDwithStartTime.get(triggerNew.event__c);
            for (Event_Speaker__c es : esInSpeakers) {
                if (
                    es.speaker__c == triggerNew.speaker__c &&
                    es.event__r.Start_DateTime__c == bookTime
                ) {
                    triggerNew.Speaker__c.addError('speaker 今は空いてない');
                    triggerNew.addError('speaker 今は空いてない');
                }
            }
        }
    }
}
