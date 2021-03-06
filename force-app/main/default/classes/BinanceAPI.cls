public class BinanceAPI {
    
    @AuraEnabled
    public static String getPriceSingle(String mercadoId){
        
        Mercado__c mercado = [SELECT Id, Moeda_Primaria__c, Moeda_Secundaria__c 
                              FROM Mercado__c
                              WHERE Id = :mercadoId];

        String pair = mercado.Moeda_Primaria__c + mercado.Moeda_Secundaria__c;
        pair = pair.replace('USD', 'USDT');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.binance.com/api/v3/ticker/price?symbol=' + pair);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            SymbolPrice sp = (SymbolPrice)JSON.deserialize(response.getBody(), SymbolPrice.class);
            return sp.price;
        }else{
            return 'Erro ao acessar a API da Binance!';
        }
    }

    @AuraEnabled
    //@future (callout=true)
    public static List<SymbolPrice> getPrice(){

        //System.debug('Teste!!!');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.binance.com/api/v3/ticker/price');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<SymbolPrice> spList = (List<SymbolPrice>)JSON.deserialize(response.getBody(), List<SymbolPrice>.class);
            return spList;
        }else{
           return null;
        }
    }

    public Class SymbolPrice{
        public String symbol;
        public String price;
    }

    @AuraEnabled
    public static String getRecordTypeId(String orderType){
        String rTypeId = Schema.SObjectType.Ordem__c.getRecordTypeInfosByDeveloperName().get(orderType).getRecordTypeId();
        return rTypeId;
    }
}
