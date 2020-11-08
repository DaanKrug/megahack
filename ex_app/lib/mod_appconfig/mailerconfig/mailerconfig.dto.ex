defmodule ExApp.MailerConfig do

   def new(id,provider,name,username,password,position,
           perMonth,perDay,perHour,perMinute,perSecond,replayTo,
           lastTimeUsed,userId,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,provider,name,username,password,position,
                                            perMonth,perDay,perHour,perMinute,
                                            perSecond,replayTo,lastTimeUsed,userId,ownerId)
       true -> newTotalRows(id,provider,name,username,password,position,
                            perMonth,perDay,perHour,perMinute,perSecond,replayTo,
                            lastTimeUsed,userId,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,provider,name,username,password,position,
                       perMonth,perDay,perHour,perMinute,perSecond,replayTo,
                       lastTimeUsed,userId,ownerId) do
     %{
       id: id,
       provider: provider,
       name: name,
       username: username,
       perMonth: perMonth,
       perDay: perDay,
       perHour: perHour,
       perMinute: perMinute,
       perSecond: perSecond,
       replayTo: replayTo,
       ownerId: ownerId,
       lastTimeUsed: lastTimeUsed,
       userId: userId,
       password: password,
       position: position
     }
   end
   
   defp newTotalRows(id,provider,name,username,password,position,
                     perMonth,perDay,perHour,perMinute,perSecond,replayTo,
                     lastTimeUsed,userId,ownerId,totalRows) do
     %{
       id: id,
       provider: provider,
       name: name,
       username: username,
       perMonth: perMonth,
       perDay: perDay,
       perHour: perHour,
       perMinute: perMinute,
       perSecond: perSecond,
       replayTo: replayTo,
       ownerId: ownerId,
       lastTimeUsed: lastTimeUsed,
       userId: userId,
       password: password,
       position: position,
       totalRows: totalRows
     }
   end
   
end