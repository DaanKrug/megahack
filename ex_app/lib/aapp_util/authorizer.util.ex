defmodule ExApp.AuthorizerUtil do

  alias ExApp.SanitizerUtil
  alias ExApp.SessionServiceApp
  alias ExApp.UserServiceApp
  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.DateUtil
  
  def storeHistoryAccess(ip,token,resource) do
  	SessionServiceApp.storeHistoryAccess(ip,token,resource)
  end
  
  def validateAccessByHistoryAccess(ip,token,resource,timesOnLastMinute) do
    (SessionServiceApp.countHistoryAccess(ip,token,resource,DateUtil.minusMinutesSql(1)) < timesOnLastMinute)
  end
  
  def canAuthenticate(email,_token) do
    cond do
      (!SanitizerUtil.validateEmail(email)) -> false
      (UserServiceApp.loadIdByEmail(email) > 0) -> SessionServiceApp.canAuthenticate(email)
      true -> false
    end
  end
  
  def setAuthenticated(user,token,ip) do
    email = cond do
      (String.contains?(token,"_conferencist")) -> MapUtil.get(user,:a2_email)
      true -> MapUtil.get(user,:email)
    end
    cond do
      (token == "" or ip == "") -> false
      true -> SessionServiceApp.setAuthenticated(token,email,MapUtil.get(user,:id),ip)
    end
  end
  
  def isAuthenticated(ownerId,token,ip) do
    SessionServiceApp.isAuthenticated(token,ownerId,ip)
  end
  
  def unAuthenticate(token) do
    SessionServiceApp.unAuthenticate(token)
  end
  
  def validateOwnership(object,ownerId,_token,_permission) do
  	MapUtil.get(object,:ownerId) == ownerId
  end
  
  def validateAccess(ownerId,categories,permission) do
    permission = getPermissionOnPermissionGroups(permission)
    user = UserServiceApp.loadForPermission(ownerId)
    userPermissions = MapUtil.get(user,:permissions) |> StringUtil.split(",")
    userCategory = MapUtil.get(user,:category)
    noPermission = (length(userPermissions) == 0 or !Enum.member?(userPermissions,permission))
    enrollPermissions = Enum.member?(getEnrollEntities(),permission)
    cond do
      (nil == user or nil == permission or MapUtil.get(user,:active) != 1) -> false
      (userCategory == "enroll" and enrollPermissions) -> true
      (userCategory != "admin_master" and noPermission) -> false
      (nil == categories or length(categories) == 0) -> true
      true -> Enum.member?(categories,userCategory)
    end
  end
  
  defp getEnrollEntities() do
    ["image_write","image"]
  end
  
  def getAdditionalConditionsOnLoad(ownerId) do
    user = UserServiceApp.loadForPermission(ownerId)
    category = user |> MapUtil.get(:category)
    ownerOwnerId = user |> MapUtil.get(:ownerId)
    cond do
      (category == "enroll") -> " and ownerId in(#{ownerId},#{ownerOwnerId}) "
      (category == "admin") 
        -> """
           and ownerId in(#{ownerId},#{ownerOwnerId},#{UserServiceApp.loadChildIds(ownerId)}) 
           """
      true -> ""
    end
  end
  
  def setAuditingExclusions(token,ownerId,conditions) do
    SessionServiceApp.setAuditingExclusions(token,ownerId,
                        String.contains?("#{conditions}","0x{auditingExclusions}"))
  end
  
  def getDeletedAt(token \\ nil,ownerId \\ nil) do
    auditingExclusions = cond do
      (nil == token or nil == ownerId or token == "" or !(ownerId > 0)) -> false
      true -> SessionServiceApp.getAuditingExclusions(token,ownerId)
    end
    trueArray = ["true","1",true,1]
    cond do
      (Enum.member?(trueArray,"#{auditingExclusions}")) 
        -> """
           (deleted_at > "0000-00-00 00:00:00")
           """
      true -> """
              (deleted_at is null or deleted_at = "0000-00-00 00:00:00")
              """
    end
  end
  
  defp getPermissionOnPermissionGroups(permission) do
    cancerdiagnosticGroup = ["cancertype","leveloneestadiament","leveltwoestadiament"]
    cancerdiagnosticWriteGroup = ["cancertype_write","leveloneestadiament_write",
                                  "leveltwoestadiament_write"]
    userGroup = ["additionaluserinfo"]
    userWriteGroup = ["additionaluserinfo_write"]
    cond do
      (Enum.member?(cancerdiagnosticGroup,permission)) -> "cancerdiagnostic"
      (Enum.member?(cancerdiagnosticWriteGroup,permission)) -> "cancerdiagnostic_write"
      (Enum.member?(userGroup,permission)) -> "user"
      (Enum.member?(userWriteGroup,permission)) -> "user_write"
      true -> permission
    end
  end
  
end








