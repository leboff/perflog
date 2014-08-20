global class PerfLogController{

    @RemoteAction
    global static void printLog(String msg, String url, String id, String params){
        Url u = new Url(url);

        createLog(timeInMs(msg), u.getPath(), id, getParams(params, u.getQuery()));
    }

    private static Integer timeInMs(String msg){
        //get rid of leading/trailing ws
        msg = msg.trim();
        
        //split on page generation time
        List<String> ss = msg.split('page generation time: ');
        
        //get the substring now up until ms
        msg = ss[1].subString(0, ss[1].length()-2);

        return Integer.valueOf(msg);
    }
    
    private static void createLog(Integer gtime, String path, String id, Map<String, String> params){
        Performance_Log__c pl = new Performance_Log__c();
        
        pl.page_name__c = path;
        pl.Page_Generation_Time__c = gtime;
        pl.requesting_user__c = UserInfo.getUserId();
        pl.record_id__c = id;
        insert pl;

        List<Performance_Log_Parameter__c> plps = new List<Performance_Log_Parameter__c>();
        for(String param : params.keySet()){
            Performance_Log_Parameter__c plp = new Performance_Log_Parameter__c();
            plp.name__c = param;
            plp.value__c = params.get(param);
            plp.Performance_Log__c = pl.id;
            plps.add(plp);
        }

        insert plps;

    }

    private static Map<String, String> getParams(String params, String query){
        Map<String, String> paramMap = new Map<String, String>();

        if(!String.isBlank(params) && !String.isBlank(query)){
            List<String> paramQuery = query.split('&');
            Set<String> includeParams = new Set<String>(params.split(','));
            System.debug(includeParams);
            System.debug(paramQuery);
            for(String param : paramQuery){
                List<String> keyValue = param.split('=');
                if(includeParams.contains(keyValue[0])){
                    paramMap.put(keyValue[0], keyValue[1]);
                }
            }    
        }
        
        return paramMap;
    }

}