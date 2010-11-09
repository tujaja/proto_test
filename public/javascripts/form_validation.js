//整形用文字セット
var cs = {
  alpha:{
    han:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-()@.,",
    zen:"ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ０１２３４５６７８９−（）＠．，"},
  space:{
    han:" ",
    zen:"　"},
  kata:{
    han:"ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｯｬｭｮｰﾟﾟｳｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾊﾋﾌﾍﾎﾊﾋﾌﾍﾎ",
    zen:"アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンァィゥェォッャュョー゛゜ヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ"},
  hira:{
    zen:"あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんぁぃぅぇぉっゃゅょー゛゜ゔがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ"}
};

//半角全角変換のフロントエンド
function cnvKana(str, option){
  if (!option) option = 'KV';
  var collapse = option.indexOf('V')>=0;//濁点・半濁点を一文字にまとめる
  if (option.indexOf('a')>=0) str = cnvKanaMain(str, cs.alpha.zen, cs.alpha.han);//全角英数字→半角英数字
  if (option.indexOf('A')>=0) str = cnvKanaMain(str, cs.alpha.han, cs.alpha.zen);//半角英数字→全角英数字
  if (option.indexOf('s')>=0) str = cnvKanaMain(str, cs.space.zen, cs.space.han);//全角スペース→半角スペース
  if (option.indexOf('S')>=0) str = cnvKanaMain(str, cs.space.han, cs.space.zen);//半角スペース→全角スペース
  if (option.indexOf('k')>=0) str = cnvKanaMain(str, cs.kata.zen, cs.kata.han);//全角カナ→半角カナ
  if (option.indexOf('K')>=0) str = cnvKanaMain(str, cs.kata.han, cs.kata.zen, collapse);//半角カナ→全角カナ
  if (option.indexOf('h')>=0) str = cnvKanaMain(str, cs.hira.zen, cs.kata.han);//全角かな→半角カナ
  if (option.indexOf('H')>=0) str = cnvKanaMain(str, cs.kata.han, cs.hira.zen, collapse);//半角カナ→全角かな
  if (option.indexOf('c')>=0) str = cnvKanaMain(str, cs.kata.zen, cs.hira.zen);//全角カナ→全角かな
  if (option.indexOf('C')>=0) str = cnvKanaMain(str, cs.hira.zen, cs.kata.zen);//全角かな→全角カナ
  return str;
}

//半角全角変換の処理
function cnvKanaMain(str, from, to, collapse){
  var retVal = '', chr, idx, margin, alt;
  for(var i=0; i<str.length; i++){
    chr = str.charAt(i);
    idx = from.indexOf(chr);
    if (idx>=0) chr = to.charAt(idx);
    if (to.charAt(0)=='ｱ' && idx >= 58){
      chr += idx<79 ? 'ﾞ' : 'ﾟ';
    }
    if (collapse && i+1<str.length && (str.charAt(i+1)=='ﾞ' || str.charAt(i+1)=='ﾟ')){
      margin = str.charAt(i+1)=='ﾞ' ? 58 : 79;
      idx = from.indexOf(str.charAt(i), margin);
      alt = str.charAt(i+1)=='ﾞ' ? '゛' : '゜';
      chr = idx>=0 ? to.charAt(idx) : chr+alt;
      i++;
    }
    retVal += chr;
  }
  return retVal;
}

//整形用
String.prototype.cnvKana = function(option){
  return cnvKana(this, option);
}
String.prototype.trim = function(){
  return this.replace(/^\s+|\s+$/g,'');
}
String.prototype.cnvZip= function(){
  var str = this.cnvKana('a');
  str = str.replace(/[^\d]/g, '');
  if (str.length > 3) str = str.slice(0,3)+'-'+str.slice(3,7);
  return str;
}
String.prototype.cnvPhone = function(){
  var str = this.cnvKana('as');
  str = str.replace(/[\(\)\s]/g, '-');
  str = str.replace(/[^\d-]/g, '');
  str = str.replace(/^-+|-+$/g, '');
  str = str.replace(/-+/g, '-');
  return str;
}

//検証用
String.prototype.isNotEmpty = function(){
  return this != '';
}
String.prototype.isEmpty = function(){
  return this == '';
}
String.prototype.isShorterThan = function(n){
  return this.length <= n;
}
String.prototype.isLongerThan = function(n){
  return this.length >= n;
}
String.prototype.isZip = function(){
  return this.isEmpty() || /^\d{3}-\d{4}$/.test(this);
}
String.prototype.isPhone = function(){
  return this.isEmpty() || /^\d{2,4}-\d{1,4}-\d{4}$/.test(this);
}
String.prototype.isEmail = function(){
  return this.isEmpty() || /^([\w-]+\.?)+@[\w-]+(\.([\w-]+))+$/.test(this);
}
String.prototype.isComposedOf = function(str){
  for(var i=0; i<this.length; i++)
    if (str.indexOf(this.charAt(i))==-1)
      return false;
  return true;
}

String.prototype.isUnique = function(attr){
  return isUnique(this, attr);
}

// id, domain, phone, ...
// users(moedl)の依存をとりのぞく
var isUnique = function(val, url) {
  var uniqueness = false
  if (!val) return uniqueness;
  new Ajax.Request( url + val + '.json',
    { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) {
        var ret = response.responseJSON;
        uniqueness = ret["unique"];
      }
    });
  return uniqueness;
}



//フィードバックヘルパー
var insertOKImage = function(ok, elm) {
  if(ok) { elm.update( new Element('img', { src: '/images/ok.png' } )); }
  else   { elm.update( new Element('img', { src: '/images/ng.png' } )); }
}

var insertMessage = function(ok, elm, msg) {
   if(!ok) { elm.insert(msg); }
}

//フォーム検証フレームワーク
var formValidation = function(name, feedback, fields){
  var form = document.forms[name];
  for (var i=0; i<form.elements.length; i++){
    (function(){
      var elm = form.elements[i];
      var f = fields[elm.name];
      if (f){
        f.element = elm;
        f.process = function(){
          var ok = true;
          if (f.convert) f.element.value = f.convert(f.element.value);
          if (f.validation) ok = f.validation(f.element.value);
          if (f.feedback) f.feedback(ok, f.element);
          return ok;
        }
        elm.onblur = function(e){ f.process() }
      }
    })();
  }
  form.onsubmit = function(){
    var all_ok = true;
    for (key in fields)
      if (fields[key] && !fields[key].process())
        all_ok = false;
    return feedback(all_ok);
  };
}

