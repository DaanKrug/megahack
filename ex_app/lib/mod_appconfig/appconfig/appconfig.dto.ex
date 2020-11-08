defmodule ExApp.AppConfig do

   def new(id,name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
           useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
           useAuthorInfo,authorInfo,
           active,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,description,site,usePricingPolicy,pricingPolicy,
                                            usePrivacityPolicy,privacityPolicy,useUsetermsPolicy,usetermsPolicy,
                                            useUsecontractPolicy,usecontractPolicy,
                                            useAuthorInfo,authorInfo,
                                            active,ownerId)
       true -> newTotalRows(id,name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
                            useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
                            useAuthorInfo,authorInfo,
                            active,ownerId,totalRows)
     end
   end
     
   defp newNoTotalRows(id,name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
                       useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
                       useAuthorInfo,authorInfo,
                       active,ownerId) do
     %{
       id: id,
       name: name,
       description: description,
       site: site,
       usePricingPolicy: usePricingPolicy,
       pricingPolicy: pricingPolicy,
       usePrivacityPolicy: usePrivacityPolicy,
       privacityPolicy: privacityPolicy,
       useUsetermsPolicy: useUsetermsPolicy,
       usetermsPolicy: usetermsPolicy,
       useUsecontractPolicy: useUsecontractPolicy,
       usecontractPolicy: usecontractPolicy,
       useAuthorInfo: useAuthorInfo,
       authorInfo: authorInfo,
       active: active,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
                     useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
                     useAuthorInfo,authorInfo,
                     active,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       description: description,
       site: site,
       usePricingPolicy: usePricingPolicy,
       pricingPolicy: pricingPolicy,
       usePrivacityPolicy: usePrivacityPolicy,
       privacityPolicy: privacityPolicy,
       useUsetermsPolicy: useUsetermsPolicy,
       usetermsPolicy: usetermsPolicy,
       useUsecontractPolicy: useUsecontractPolicy,
       usecontractPolicy: usecontractPolicy,
       useAuthorInfo: useAuthorInfo,
       authorInfo: authorInfo,
       active: active,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end