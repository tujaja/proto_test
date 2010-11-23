<div id="error"></div>

<%#= javascript_include_tag "form_validation" %>
<script type="text/javascript">
<!-- <![CDATA[

  var fields = {
    'label[domain]':{
      convert: function(val){ return val.cnvKana('aV').trim() },
      validation: function(val){ return val.isNotEmpty() && val.isShorterThan(16) },
      feedback: function(ok, elm){
        var sp = $('domain');
        //insertOKImage(ok, sp);
        insertMessage(ok, sp, 'だめです');
      }
    },
  };
  var feedback = function(ok){
    if (!ok) {
      $('error').update("フォームの内容に不備があるようです。再度の確認をお願いいたします。");
    }
    return ok;
  };
  new formValidation('new_label', feedback, fields);
// ]]> -->
</script>
