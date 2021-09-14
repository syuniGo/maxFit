trigger Event_SpeakerTrigger on Event_Speaker__c(
    before insert,
    after insert,
    before update,
    after update
) {
    if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
        Event_SpeakerTriggerHandle.Event_SpeakerTriggerHandle(Trigger.new);
    }

}
