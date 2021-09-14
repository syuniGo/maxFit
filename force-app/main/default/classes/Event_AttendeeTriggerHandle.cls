public with sharing class Event_AttendeeTriggerHandle {
    public static void Event_AttendeeTriggerHandle(
        List<Event_Attendee__c> triggerNew
    ) {
        Set<String> EventIdSet = new Set<String>();
        Set<String> AttendeeIdSet = new Set<String>();

        for (Event_Attendee__c evtAtt : triggerNew) {
            EventIdSet.add(evtAtt.Event__c);
            AttendeeIdSet.add(evtAtt.Attendee__c);
        }

        list<Event__c> evtInfos = [
            SELECT
                Name__c,
                Event_Organizer__r.Name,
                Start_DateTime__c,
                End_Date_Time__c,
                Location__r.Name,
                Location__r.Country__c,
                Location__r.State__c,
                Location__r.City__c,
                Location__r.Street__c
            FROM Event__c
            WHERE id IN :EventIdSet
        ];
        List<Attendees__c> attInfos = [
            SELECT Name, Phone__c, Email__c
            FROM Attendees__c
            WHERE id IN :AttendeeIdSet
        ];

        Map<Id, Event__c> idWithEvt = new Map<Id, Event__c>();
        Map<Id, Attendees__c> idWithAtt = new Map<Id, Attendees__c>();

        for (Event__c evtInfo : evtInfos) {
            idWithEvt.put(evtInfo.id, evtInfo);
        }
        for (Attendees__c attInfo : attInfos) {
            idWithAtt.put(attInfo.id, attInfo);
        }

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for (Event_Attendee__c newEvtAtt : triggerNew) {
            Event__c relateEvt = idWithEvt.get(newEvtAtt.Event__c);
            Attendees__c relateAtt = idWithAtt.get(newEvtAtt.Attendee__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new List<String>{ relateAtt.Email__c };
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName(relateEvt.Event_Organizer__r.Name);
            mail.setSubject('Pass for the ' + relateEvt.Name__c);
            String locaton =
                'https://www.google.com/maps/place/' +
                relateEvt.Location__r.Street__c;

            String hrefForLocation =
                '<a href="' +
                locaton +
                '"' +
                'target="_blank">Here</a>';
            String emailBody =
                'Dear ' +
                relateAtt.Name +
                ',<br/><br/>' +
                'Thank you for registering for ' +
                relateEvt.Name__c +
                ' which will be Organized on ' +
                relateEvt.Start_DateTime__c +
                ' & will be held in ' +
                relateEvt.Location__r.Name +
                '.<br/>We are excited to have you,' +
                'see you in the event. <br/>' +
                'Find the Google Map Location for the Event ' +
                hrefForLocation +
                '.<br/><br/><br/>' +
                'Thanks,<br/>' +
                relateEvt.Event_Organizer__r.Name;

            mail.setHtmlBody(emailBody);
            emailList.add(mail);
        }
        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                emailList,
                false
            );
            for (Messaging.SendEmailResult email : results) {
                System.debug(email.isSuccess());
                if (!email.isSuccess()) {
                    List<Messaging.SendEmailError> errors = email.getErrors();
                    ErrorHandle.doHandleExceptionWithError(
                        JSON.serialize(errors),
                        'EventAttendeeTriggerHandler'
                    );
                }
            }
        } catch (System.Exception ex) {
            ErrorHandle.doHandleException(ex, 'EventAttendeeTriggerHandler');
        }
    }
}
