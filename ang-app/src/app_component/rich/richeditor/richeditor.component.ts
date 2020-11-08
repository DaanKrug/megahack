import { Component, EventEmitter, Input, Output, 
	     OnInit, OnDestroy, AfterViewInit }        from '@angular/core';
import { NgControl } from '@angular/forms';

import { RichBaseComponent } from '../richbase.component';

declare const tinymce: any;

@Component({
  selector: 'rich-editor',
  templateUrl: './richeditor.component.html'
})
export class RichEditorComponent extends RichBaseComponent implements OnInit, OnDestroy, AfterViewInit{

  editor: any;
  editorId: string;
  interval: any;
  oldValue: string;

  constructor(private ngControl: NgControl) {
	  super(ngControl);
  }
 
  ngOnInit(){
	  super.ngOnInit();
	  this.editorId = this.formControlName + '_richeditor';
  }
  
  ngOnDestroy(){
	  this.stopInterval();
	  tinymce.remove(this.editor);
      this.editor = null;
      this.editorId = null;
      this.oldValue = null;
      super.ngOnDestroy();
  }
   
  ngAfterViewInit(){
	  var thisThis = this;
	  var buttons = 'h1 h2 h3 h4 h5 h6 | bold italic underline ';
	  buttons += '| justifyleft justifycenter justifyright justifyfull ';
	  buttons += '| bullist numlist | forecolor backcolor ';
	  buttons += '| link image media | removeformat code fullscreen';
	  tinymce.init({
		  readonly : this.onlyRead ? 1 : 0,
		  selector: '#' + this.editorId,
		  theme: 'silver',
		  plugins: 'lists, link, image, media, code, fullscreen',
		  toolbar: buttons,
		  menubar: false,
		  setup: editor => {
		      thisThis.editor = editor;
		      editor.on('init', () => { thisThis.initializeEditor(); });
		      editor.on('keyup', () => { thisThis.setContent(editor.getContent()); });
		      editor.on('change', () => { thisThis.setContent(editor.getContent()); });
		      editor.on('blur', () => { thisThis.setContent(editor.getContent()); thisThis.startInterval(); });
		      editor.on('mouseleave', () => { thisThis.startInterval(); });
		      editor.on('mouseout', () => { thisThis.startInterval(); });
		      editor.on('focus', () => { thisThis.stopInterval(); });
		      editor.on('mouseenter', () => { thisThis.stopInterval(); });
		      editor.on('mouseover', () => { thisThis.stopInterval(); });
		  }
	  });
  }
  
  initializeEditor(){
	  if(null==this.editor){
		  setTimeout(() => {this.initializeEditor();},100);
	  }
	  this.readToEditor();
  }
  
  startInterval(){
	  if(null != this.interval){
		  return;
	  }
	  this.interval = setInterval(() => {this.readToEditor();},500);
  }
  
  stopInterval(){
	  if(null == this.interval){
		  return;
	  }
	  clearInterval(this.interval);
	  this.interval = null;
  }
  
  readToEditor(){
	  if(null == this.formGroup){
		  this.stopInterval();
		  return;
	  }
	  var value = this.formGroup.value[this.formControlName];
	  if(null == value){
		  value = '';
	  }
	  if(value.trim() == this.oldValue){
		  return;
	  }
	  this.oldValue = value.trim();
	  this.adjustIndicator(value);
	  this.editor.setContent(value);
  }
  
  setContent(value){
	  this.adjustIndicator(value);
	  super.setContent(value);
  }
  
  adjustIndicator(value){
	  var elemError = document.getElementById('indicatorError_' + this.id);
	  var elemInfo = document.getElementById('indicatorInfo_' + this.id);
	  if(null == elemError || null == elemInfo){
		  return;
	  }
	  elemError.innerHTML = '';
	  elemInfo.innerHTML = '';
	  if(!(this.minchars > 0) && !(this.maxchars > 0)){
		  return;
	  }
	  value = value.replace(/<p>/gi,'').replace(/<\/p>/gi,'');
	  value = value.replace(/<br\/>/gi,'').replace(/<br \/>/gi,'');
	  value = value.replace(/&nbsp;/gi,' ');
	  value = value.replace(/&.*?;/gi,'0');
	  var size = value.trim().length;
	  if(this.minchars > 0 && size < this.minchars){
		  elemError.innerHTML = 'Atenção: Tamanho [' + size + '] menor que o mínimo [' + this.minchars + '].';
		  return;
	  }
      if(this.maxchars > 0 && size > this.maxchars){
    	  elemError.innerHTML = 'Atenção: Tamanho [' + size + '] maior que o máximo [' + this.maxchars + '].';
    	  return;
	  }
      elemInfo.innerHTML = 'Ok: Tamanho [' + size + '] adequado ao intervalo mínimo/máximo.';
  }
  
}









