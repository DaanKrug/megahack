import { Input, Output, OnInit, OnDestroy, AfterViewInit }        from '@angular/core';

import { BaseCustomComponent } from '../basecustomcomponent';

const alphaE: string[] = [
	'Ñ','Ã','Á','À','Â','Ä','É','È','Ê','Ë','Í','Ì','Î','Ï','Õ','Ó','Ò','Ô','Ö','Ú','Ù','Û','Ü','Ç'
];
const alphae: string[] = [
	'ñ','ã','á','à','â','ä','é','è','ê','ë','í','ì','î','ï','õ','ó','ò','ô','ö','ú','ù','û','ü','ç'
];
const alphaA: string[] = [
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
];
const alphaa: string[] = [
	'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
];
const alphaEntities: string[] = [
	'&Atilde;','&Aacute;','&Agrave;','&Acirc;','&Auml;',
	'&Eacute;','&Egrave;','&Ecirc;','&Euml;',
	'&Iacute;','&Igrave;','&Icirc;','&Iuml;',
	'&Otilde;','&Oacute;','&Ograve;','&Ocirc;','&Ouml;',
	'&Uacute;','&Ugrave;','&Ucirc;','&Uuml;','&Ccedil;'
];
const alphaentities: string[] = [
	'&atilde;','&aacute;','&agrave;','&acirc;','&auml;',
	'&eacute;','&egrave;','&ecirc;','&euml;',
	'&iacute;','&igrave;','&icirc;','&iuml;',
	'&otilde;','&oacute;','&ograve;','&ocirc;','&ouml;',
	'&uacute;','&ugrave;','&ucirc;','&uuml;','&ccedil;'
];
const nums: string[] = ['0','1','2','3','4','5','6','7','8','9'];
const doubles: string[] = ['0','1','2','3','4','5','6','7','8','9',',','-'];
const specials: string[] = [
	'(',')','*','-','+','%','@','_','.',',','$',':',' ','|',';','/','\\','?','=','&','[',']','{','}'
];

export class RichBaseComponent extends BaseCustomComponent implements OnInit, OnDestroy{

  @Input() id: string;
  @Input() label: string;
  @Input() titlee: string;
  @Input() formControlName: string;
  @Input() widthPerc: number;
  @Input() breakBefore: boolean;
  @Input() breakBeforeDouble: boolean;
  @Input() checkedd: boolean;
  @Input() formGroup: any;
  @Input() zeroLabel: string;
  @Input() emptyLabel: string;
  @Input() minusOneLabel: string;
  @Input() selectedObject: any;
  @Input() oldSelectedObject: any;
  @Input() objects: any[];
  @Input() selectedObjects: any[];
  @Input() onlySelect: boolean;
  @Input() noRender: boolean;
  @Input() onlyRead: boolean;
  @Input() minchars: number;
  @Input() maxchars: number;
  @Input() rowss: number;
  @Input() minValue: number;
  @Input() maxValue: number;
  @Input() maskk: string;
  @Input() preserveSpecialCharacters: boolean;
  @Input() className: string;
  @Input() activated: boolean;
  @Input() placeholderr: string;
  
  readOnlyLabel: string;
  
  constructor(private ngControll: any) {
	  super();
  }
  
  ngOnInit(){
	  this.label = (null != this.label) ? this.removeDoubleAndBreakingSpaces(this.label) : null;
	  if(null == this.id){
		  this.id = this.formControlName;
	  }
	  if(null == this.titlee){
		  this.titlee = this.label;
	  }
	  this.titlee = this.removeDoubleAndBreakingSpaces(this.titlee);
	  if(null == this.widthPerc || this.widthPerc < 1 || this.widthPerc > 100){
		  this.widthPerc = 100;
	  }
	  if(null == this.rowss){
		  this.rowss = 1;
	  }
	  if(null == this.minchars || this.minchars < 0){
		  this.minchars = 0;
	  }
	  if(null == this.maxchars || this.maxchars < 0){
		  this.maxchars = 0;
	  }
	  if(this.maxchars > 254){
		  var newRows = parseInt('' + (this.maxchars/130));
		  if(newRows > this.rowss){
			  this.rowss = newRows;
		  }
	  }
	  if(null == this.selectedObjects){
		  this.selectedObjects = [];
	  }
	  if(null == this.placeholderr){
		  this.placeholderr = '';
	  }
	  this.prepareObjects();
  }
  
  ngAfterViewInit(){
	  setTimeout(() => {
		  this.readOnlyLabel = this.getLabelForSelectedObject();
	  },300);
  }
  
  ngOnDestroy(){
	  this.id = null;
	  this.label = null;
	  this.titlee = null;
	  this.formControlName = null;
      this.widthPerc = null;
      this.breakBefore = null;
      this.breakBeforeDouble = null;
      this.checkedd = null;
      this.formGroup = null;
      this.zeroLabel = null;
      this.emptyLabel = null;
      this.minusOneLabel = null;
      this.selectedObject = null;
      this.oldSelectedObject = null;
      this.objects = null;
      this.selectedObjects = null;
      this.onlySelect = null;
      this.noRender = null;
      this.onlyRead = null;
      this.minchars = null;
      this.maxchars = null;
      this.rowss = null;
      this.minValue = null;
      this.maxValue = null;
      this.maskk = null;
      this.preserveSpecialCharacters = null;
      this.className = null;
      this.activated = null;
      this.placeholderr = null;
      this.readOnlyLabel = null;
  }
  
  nothing(){}//do nothing 
  
  setContent(content){
	  this.formGroup.controls[this.formControlName].patchValue(content);
  }
  
  getContent(){
	  if(undefined != this.ngControll && null != this.ngControll){
		  return this.ngControll.value;
	  }
	  if(undefined == this.formGroup || null == this.formGroup){
		  return null;
	  }
	  return this.formGroup.value[this.formControlName];
  }
  
  prepareObjects(){
	  if(undefined == this.objects || null == this.objects){
		  return;
	  }
	  var size = this.objects.length;
	  for(var i = 0; i < size; i++){
		  this.objects[i].title = this.removeDoubleAndBreakingSpaces(this.objects[i].title);
		  this.objects[i].label = this.removeDoubleAndBreakingSpaces(this.objects[i].label);
	  }
  }
  
  getObjectForValue(){
	  if(undefined == this.objects || null == this.objects){
		  return null;
	  }
	  var value = this.getContent();
	  if(null == value){
		  return null;
	  }
	  var size = this.objects.length;
	  for(var i = 0; i < size; i++){
		  if(null != this.objects[i].id && this.objects[i].id == value){
			  return this.objects[i];
		  }
		  if(null != this.objects[i].value && this.objects[i].value == value){
			  return this.objects[i];
		  }
	  }
	  return null;
  }
  
  getLabelForObject(object){
	  if(null == object){
		  return null;
	  }
	  if(null != object.name){
		  return object.name;
	  }
	  if(null != object.label){
		  return object.label;
	  }
	  if(null != object.identifier){
		  return object.identifier;
	  }
	  return null;
  }
  
  getLabelForSelectedObject(){
	  return this.getLabelForObject(this.getObjectForValue());
  }
  
  removeDoubleAndBreakingSpaces(value){
	  if(undefined == value || null == value){
		  return null;
	  }
	  value = value.replace(/\t/gi,'');
	  value = value.replace(/\r/gi,'');
	  value = value.replace(/\n/gi,'');
	  while(value.indexOf('  ') != -1){
		  value = value.replace('  ',' ');
	  }
	  return this.revertSpecialEntities(value);
  }
  
  revertSpecialEntities(value){
	  var size = alphaEntities.length;
	  for(var i = 0; i < size; i++){
		  while(value.indexOf(alphaEntities[i]) != -1){
			  value = value.replace(alphaEntities[i],alphaE[i]);
		  }
	  }
	  size = alphaentities.length;
	  for(var i = 0; i < size; i++){
		  while(value.indexOf(alphaentities[i]) != -1){
			  value = value.replace(alphaentities[i],alphae[i]);
		  }
	  }
	  return value;
  }
  
  truncateAndPatch(value){
      if(this.maxchars > 0 && value.length > this.maxchars){
		  value = value.substring(0,this.maxchars);
	  }
	  this.setContent(value);
  }
  
  numberGreaterEqual(value,greater){
	  if(undefined == value || null == value){
		  return false;
	  }
	  if(undefined == greater || null == greater){
		  return true;
	  }
	  var n = parseFloat(value.replace(',','.'));
	  var g = parseFloat(greater.replace(',','.'));
	  return (n >= g);
  }
	
  numberSmallerEqual(value,smaller){
	  if(undefined == value || null == value){
		  return false;
	  }
	  if(undefined == smaller || null == smaller){
		  return true;
	  }
	  var n = parseFloat(value.replace(',','.'));
	  var s = parseFloat(smaller.replace(',','.'));
	  return (n <= s);
  }
  
  emptyObject(object){
	  return (undefined == object || null == object);
  }
  
  emptyString(value){
	  return (this.emptyObject(value) || ('' + value).trim() == '');
  }
  
  isValidInputAlphaChar(char){
	  return (char == ' ' || alphaA.includes(char) || alphaa.includes(char)
				|| alphaE.includes(char) || alphae.includes(char));
  }
  
  isValidInputAlphaNumChar(char){
	  return (this.isValidInputAlphaChar(char) || doubles.includes(char));
  }
  
  isValidInputAlphaNumNameChar(char){
	  return ([' ','_'].includes(char) || alphaA.includes(char) || alphaa.includes(char)
	          || nums.includes(char));
  }
  
  isValidInputTextChar(char){
	  return (this.isValidInputAlphaChar(char) || nums.includes(char) || specials.includes(char));
  }
  
  scapeInvalidCharsFromInputText(value){
	  var value2 = '';
	  var size = value.length;
	  for(var i = 0; i < size; i++){
		  if(this.isValidInputTextChar(value.charAt(i))){
			  value2 += value.charAt(i);
		  }
	  }
	  return value2;
  }
  
  scapeInvalidCharsFromInputAlpha(value){
	  var value2 = '';
	  var size = value.length;
	  for(var i = 0; i < size; i++){
		  if(this.isValidInputAlphaChar(value.charAt(i))){
			  value2 += value.charAt(i);
		  }
	  }
	  return value2;
  }
  
  scapeInvalidCharsFromInputAlphaNumName(value){
	  var value2 = '';
	  var size = value.length;
	  for(var i = 0; i < size; i++){
		  if(this.isValidInputAlphaNumNameChar(value.charAt(i))){
			  value2 += value.charAt(i);
		  }
	  }
	  return value2;
  }
  
  scapeInvalidCharsFromInputAlphaNum(value){
	  var value2 = '';
	  var size = value.length;
	  for(var i = 0; i < size; i++){
		  if(this.isValidInputAlphaNumChar(value.charAt(i))){
			  value2 += value.charAt(i);
		  }
	  }
	  return value2;
  }
	
  scapeInvalidCharsFromInputNumber(value){
	  var value2 = '';
	  var size = value.length;
	  var ccommas = 0;
	  var comma = ',';
	  var minus = '-';
	  for(var i = 0; i < size; i++){
		  if((i == 0 || i == (size - 1) || ccommas > 0) && value.charAt(i) == comma){
			  continue;
		  }
		  if(i != 0 && value.charAt(i) == minus){
			  continue;
		  }
		  if(doubles.includes(value.charAt(i))){
			  value2 += value.charAt(i);
		  }
		  if(value.charAt(i) == comma){
			  ccommas ++;
		  }
	  }
	  return value2;
  }
  
  adjustInputTextValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  var value2 = this.scapeInvalidCharsFromInputText(value);
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
  
  adjustInputAlphaValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  var value2 = this.scapeInvalidCharsFromInputAlpha(value);
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
  
  adjustInputAlphaNumNameValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  var value2 = this.scapeInvalidCharsFromInputAlphaNumName(value);
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
  
  adjustInputAlphaNumValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  var value2 = this.scapeInvalidCharsFromInputAlphaNum(value);
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
  
  adjustInputNumberValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  var value2 = this.scapeInvalidCharsFromInputNumber(value);
	  if(this.maxchars > 0 && value2.length > this.maxchars){
		  value2 = value2.substring(0,this.maxchars);
		  value2 = this.scapeInvalidCharsFromInputNumber(value2);
	  }
	  if(null != this.minValue && !(this.numberGreaterEqual(value2,this.minValue))){
		  value2 = '' + this.minValue;
	  }
	  if(null != this.maxValue && !(this.numberSmallerEqual(value2,this.maxValue))){
		  value2 = '' + this.maxValue;
	  }
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
  
  adjustInputTextMailAddressValueAfterChange(value){
	  if(this.emptyString(value)){
		  return;
	  }
	  value = value.replace(/\n/gi,',');
	  value = value.replace(/ /gi,',');
	  value = value.replace(/;/gi,',');
	  value = value.replace(/,,/gi,',');
	  var value2 = this.scapeInvalidCharsFromInputText(value);
	  if(value2 == value){
		  return;
	  }
	  this.truncateAndPatch(value2);
  }
    
}