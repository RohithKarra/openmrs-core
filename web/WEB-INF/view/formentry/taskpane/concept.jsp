<%@ include file="/WEB-INF/template/include.jsp"%>

<openmrs:require privilege="Form Entry" otherwise="/login.htm" redirect="/formentry/taskpane/concept.htm" />

<%@ include file="/WEB-INF/template/header.jsp"%>

<script src='<%= request.getContextPath() %>/dwr/interface/DWRConceptService.js'></script>
<script src='<%= request.getContextPath() %>/dwr/engine.js'></script>
<script src='<%= request.getContextPath() %>/dwr/util.js'></script>
<script src='<%= request.getContextPath() %>/scripts/openmrsSearch.js'></script>
<script src='<%= request.getContextPath() %>/scripts/conceptSearch.js'></script>

<script type="text/javascript">

	var conceptClasses = new Array();
	var savedSearch = "";
	<request:parameters id="c" name="className">
		<request:parameterValues id="names">
			conceptClasses.push('<jsp:getProperty name="names" property="value"/>');
		</request:parameterValues>
	</request:parameters>

	var onSelect = function(conceptList) {
		for (i=0; i<conceptList.length; i++) {
			pickProblem('<%= request.getParameter("mode") %>', '//problem_list', new miniObject(conceptList[i]));
		}
	}
	
	function miniObject(c) {
		this.key = c.conceptId;
		this.value = c.name;
	}
	
	function search(delay, event) {
		var searchBox = document.getElementById("phrase");
		savedSearch = searchBox.value.toString();
		
		// stinkin' infopath hack.  It doesn't give us onkeyup or onkeypress
		var onkeydown = true;
		if (event == null || event.type == 'onkeyup')
			onkeydown = false;
		
		searchBoxChange('conceptSearchBody', searchBox, event, false, delay, onkeydown);
	}
	
	function preFillTable(concepts) {
		// append "Propose Concept" box
		concepts.push("<a href='#proposeConcept' onclick='javascript:return showProposeConceptForm();'><spring:message code="ConceptProposal.propose.new"/></a>");
		fillTable(concepts);
	}
	
	function showProposeConceptForm() {
		$('searchForm').style.display = "none";
		$('proposeConceptForm').style.display = "block";
		txt = $('proposedText');
		txt.value = savedSearch;
		txt.focus();
		return false;
	}
	
	function proposeConcept() {
		var box = $('proposedText');
		if (box.innerHTML == '')  {
			alert("Proposed Concept text must be entered");
			box.focus();
		}
		else {
			$('proposeConceptForm').style.display = "none";
			DWRConceptService.findProposedConcepts(preProposedConcepts, box.value);
		}
	}
	
	function preProposedConcepts(concepts) {
		if (concepts.length == 0) {
			var concept = new miniConcept();
			conceptList = new Array();
			conceptList.push(concept);
			onSelect(conceptList);
		}
		else {
			//display a box telling them to pick a preposed concept:
			$("preProposedAlert").style.display = "block";
			$('searchForm').style.display = "";
			fillTable(concepts);
		}
	}
	
	function miniConcept(n) {
		this.conceptId = "PROPOSED";
		if (n == null)
			this.name = $('proposedText').innerHTML;
		else
			this.name = n;
	}
	
	/*
	   Disable concept editing from within the taskpane 
	   act like simple selection instead
	*/
	function editConcept(event, index) {
		return selectObject(index);
	}
		
</script>

<style>
	#proposeConceptForm {
		display: none;
	}
	#preProposedAlert {
		display: none;
	}
	.alert {
		color: red;
	}
</style>

<h3>
	<spring:message code="diagnosis.title" />
</h3>

<div id="preProposedAlert" class="alert">
	<br>
	<spring:message code="ConceptProposal.proposeDuplicate" />
	<br>
</div>

<form method="POST" onSubmit="search(0, event); return false;" id="searchForm">
	<input name="mode" type="hidden" value='${request.mode}'>
	<input name="phrase" id="phrase" type="text" class="prompt" size="23" onkeydown="search(400, event)" />
	<br />
	<input type="checkbox" id="verboseListing" value="true" onclick="search(0, event); phrase.focus();">
	<label for="verboseListing">
		<spring:message code="dictionary.verboseListing" />
	</label>
	<br />
	<small>
		<em>
			<spring:message code="general.search.hint" />
		</em>
	</small>

	<table border="0">
		<tbody id="conceptSearchBody">
		</tbody>
	</table>

</form>

<div id="proposeConceptForm">
	<br />
	<spring:message code="ConceptProposal.proposeInfo" />
	<br /><br />
	<b><spring:message code="ConceptProposal.originalText" /></b><br />
	<textarea name="originalText" id="proposedText" rows="4" cols="20" /></textarea><br />
	<input type="button" onclick="proposeConcept()" value="<spring:message code="ConceptProposal.propose" />" /><br />
	
	<br />
	<span class="alert">
		<spring:message code="ConceptProposal.proposeWarning" />
	</span>
	
</div>

<br />

<script type="text/javascript">
  document.getElementById('phrase').focus();
</script>

<%@ include file="/WEB-INF/template/footer.jsp"%>
