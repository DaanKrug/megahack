defmodule ExApp.StringUtil do

  alias ExApp.StructUtil
  alias ExApp.NumberUtil
  
  def splitInSubstrings(string) do
    splitInSubstrings(String.graphemes(string),[])
  end
  
  def splitInSubstrings(graphemes,array) do
    cond do
      (length(array) >= length(graphemes)) -> array
      (length(array) == 0) -> splitInSubstrings(graphemes,[Enum.at(graphemes,0)])
      true -> splitInSubstrings(graphemes,
                                array ++ ["#{Enum.at(array,length(array) - 1)}#{Enum.at(graphemes,length(array))}"])
    end
  end

  def concat(stringA,stringB,joinString) do
    Enum.join([emptyIfNil(stringA),emptyIfNil(stringB)],emptyIfNil(joinString))
  end
  
  def concatMaxElements(stringA,stringB,joinString,maxSize) do
    stringA = Enum.join(StructUtil.limitArraySizeRemoveFirst(split(stringA,joinString),maxSize),emptyIfNil(joinString))
    concat(stringA,stringB,joinString)
  end
  
  def append(target,toAppend,joinString) do
    target = emptyIfNil(target)
    toAppend = emptyIfNil(toAppend)
    cond do
      (target == "") -> toAppend
      (toAppend == "") -> target
      true -> Enum.join([target,toAppend],emptyIfNil(joinString))
    end
  end
  
  def emptyIfNil(target) do
    cond do
      (nil==target) -> ""
      true -> "#{target}"
    end
  end
  
  def split(target,searched) do 
    cond do
      (nil==target) -> []
      (nil==searched) -> ["#{target}"]
      (String.contains?("#{target}","#{searched}")) -> String.split("#{target}","#{searched}")
      true -> ["#{target}"]
    end
  end
  
  def capitalize(target) do
    target
      |> split(" ")
      |> Stream.map(&String.capitalize/1)
      |> Enum.join(" ")
  end

  def replace(target,searched,replaceTo) do 
    replaceTo = emptyIfNil(replaceTo)
    recursionThrowble = String.contains?(replaceTo,"#{searched}")
    cond do
      (nil==target) -> nil
      (nil==searched) -> "#{target}"
      (recursionThrowble and String.contains?("#{target}","#{searched}")) 
        -> String.replace("#{target}","#{searched}",replaceTo)
      (String.contains?("#{target}","#{searched}")) 
        -> String.replace("#{target}","#{searched}",replaceTo) |> replace(searched,replaceTo)
      true -> "#{target}"
    end
  end
  
  def replaceAll(target,searchedArray,replaceTo) do 
    cond do
      (nil == target) -> nil
      (nil == searchedArray or length(searchedArray) == 0) -> target
      true -> replace(target,hd(searchedArray),replaceTo) 
                |> replaceAll(tl(searchedArray),replaceTo)
    end
  end
  
  def decodeUri(target) do
    mantain1 = " + "
    mantain2 = " +"
    mantain3 = "+ "
    mantain1Temp = "(((mantain1Temp)))"
    mantain2Temp = "(((mantain2Temp)))"
    mantain3Temp = "(((mantain3Temp)))"
  	target = URI.decode(target)
  	target = replace(target,mantain1,mantain1Temp)
  	target = replace(target,mantain2,mantain2Temp)
  	target = replace(target,mantain3,mantain3Temp)
  	target = replace(target,"+"," ")
  	target = replace(target,mantain1Temp,mantain1)
  	target = replace(target,mantain2Temp,mantain2)
  	replace(target,mantain3Temp,mantain3)
  end
  
  def getDecodedValueParam(arrayParams,param,separator) do
    cond do
      (nil == arrayParams or length(arrayParams) == 0) -> ""
      (String.contains?(hd(arrayParams),"#{param}#{separator}")) 
        -> decodeUri(replace(hd(arrayParams),param <> separator,""))
      true -> getDecodedValueParam(tl(arrayParams),param,separator)
    end
  end
  
  def leftZeros(string,size) do
    string = emptyIfNil(string)
    cond do
      (nil == size or !(size > 0)) -> string
      (String.length(string) >= size) -> string |> String.slice(0..size - 1)
      true -> leftZeros(append("0",string,""),size)
    end
  end
  
  def rightZeros(string,size) do
    string = emptyIfNil(string)
    cond do
      (nil == size or !(size > 0)) -> string
      (String.length(string) >= size) -> string |> String.slice(0..size - 1)
      true -> rightZeros(append(string,"0",""),size)
    end
  end
  
  def leftSpaces(string,size) do
    string = emptyIfNil(string)
    cond do
      (nil == size or !(size > 0)) -> string
      (String.length(string) >= size) -> string |> String.slice(0..size - 1)
      true -> leftSpaces(append(" ",string,""),size)
    end
  end
  
  def rightSpaces(string,size,truncate) do
    string = emptyIfNil(string)
    cond do
      (nil == size or !(size > 0)) -> string
      (String.length(string) >= size and !truncate) -> string
      (String.length(string) >= size) -> string |> String.slice(0..size - 1)
      true -> rightSpaces(append(string," ",""),size,truncate)
    end
  end
  
  def trim(string) do
    String.trim(emptyIfNil(string))
  end
  
  def trimAll(strings) do
    Enum.map(strings,fn(string) -> trim(string) end)
  end
  
  def containsOneElementOfArray(target,array) do
    cond do
      (nil == array or length(array) == 0) -> false
      (String.contains?("#{target}","#{hd(array)}")) -> true
      true -> containsOneElementOfArray(target,tl(array))
    end
  end
  
  def coalesce(value,valueIfEmptyOrNull) do
    cond do
      (nil == valueIfEmptyOrNull) -> emptyIfNil(value)
      (trim(value) == "") -> valueIfEmptyOrNull
      true -> value
    end
  end
  
  def toChar(numberString) do
    number = NumberUtil.toInteger(numberString)
    cond do
      (!(number > 0)) -> ""
      true -> List.to_string([number])
    end
  end
  
  def toCharCode(array,position) do
    cond do
      (nil == array or position >= length(array)) -> nil
      true -> array |> Enum.at(position) |> toCharCode()
    end
  end
  
  def toCharCode(stringChar) do
    stringChar 
      |> emptyIfNil() 
      |> String.to_charlist() 
      |> hd()
  end
    
end
