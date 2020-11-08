defmodule ExApp.CoordinateUtil do

	alias ExApp.StringUtil
	alias ExApp.NumberUtil
	alias ExApp.Haversine
	
	def calculateDistanceForRoute(coordinate1,coordinate2) do
	  calculateDistance(coordinate1,coordinate2) * 1.30
	end

	def calculateDistance(coordinate1,coordinate2) do
	  coordinate1Arr = coordinate1 |> StringUtil.replace("@","") |> StringUtil.split(",")
	  coordinate2Arr = coordinate2 |> StringUtil.replace("@","") |> StringUtil.split(",")
	  lat1 = coordinate1Arr |> Enum.at(0) |> NumberUtil.toFloat()
	  lat2 = coordinate2Arr |> Enum.at(0) |> NumberUtil.toFloat()
	  long1 = coordinate1Arr |> Enum.at(1) |> NumberUtil.toFloat()
	  long2 = coordinate2Arr |> Enum.at(1) |> NumberUtil.toFloat()
	  Haversine.distance({lat1, long1}, {lat2, long2})
	end
	
end