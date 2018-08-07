public class HMSA_MemberVerificationQuestion {
	@AuraEnabled
    public static List<TabInfo> getTypeRecord(String recordTypes, String objectName) {
        List<TabInfo> validRecordTypes = new List<TabInfo>();
        
        if(String.isNotBlank(objectName) && String.isNotBlank(recordTypes)) {
             List<TabInfo> tabInfoList = (List<TabInfo>) JSON.deserialize(recordTypes, List<TabInfo>.class);
            
            for(TabInfo tabData : tabInfoList) {
                String sObjectName = retrieveSObjectName(tabData.recordId);
                if(String.isNotBlank(sObjectName) && sObjectName.equalsIgnoreCase(objectName)) {
                    validRecordTypes.add(tabData);
                }
            }
        }
        return validRecordTypes;
    }
    
    private static String retrieveSObjectName(String idValue) {
        String objectName = null;
        try {
            if(String.isNotBlank(idValue)) {
                Id typeDataId = Id.valueOf(idValue);
                objectName = typeDataId.getSObjectType().getDescribe().getName();
            }
        } catch (Exception exp) {
            System.debug(LoggingLevel.ERROR, 'Error while converting Id to object name - ' + exp.getMessage());
        }
        return objectName;
    }
    
    public class TabInfo {
        @AuraEnabled
        public String recordId {set;get;}
        @AuraEnabled
        public String title {set;get;}
    }
}