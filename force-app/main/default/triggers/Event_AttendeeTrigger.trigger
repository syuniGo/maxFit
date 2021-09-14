trigger Event_AttendeeTrigger on Event_Attendee__c(
    before insert,
    after insert,
    before update,
    after update
) {
    if (Trigger.isAfter && (Trigger.isInsert)) {
        Event_AttendeeTriggerHandle.Event_AttendeeTriggerHandle(Trigger.new);
    }
}
