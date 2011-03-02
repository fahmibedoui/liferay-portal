<%--
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/dockbar/init.jsp" %>

<%
LayoutRevision layoutRevision = LayoutStagingUtil.getLayoutRevision(layout);

PortletURL portletURL = renderResponse.createRenderURL();
%>

<portlet:actionURL var="editLayoutRevisonURL">
	<portlet:param name="struts_action" value="/dockbar/edit_layouts" />
	<portlet:param name="groupId" value="<%= String.valueOf(layoutRevision.getGroupId()) %>" />
</portlet:actionURL>

<aui:form action="<%= editLayoutRevisonURL %>" enctype="multipart/form-data" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "savePage();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" />
	<aui:input name="redirect" type="hidden" value='<%= portletURL.toString() %>' />
	<aui:input name="layoutRevisionId" type="hidden" value='<%= String.valueOf(layoutRevision.getLayoutRevisionId()) %>' />
	<aui:input name="updateSessionClicks" type="hidden" value='<%= false %>' />

	<div class="dockbar dockbar-branching-and-versioning" data-namespace="<portlet:namespace />" id="stagingDockbar">
		<ul class="aui-toolbar">
			<li class="select-branch" id="selectBranch">
				<%
				List<LayoutSetBranch> branches = LayoutSetBranchLocalServiceUtil.getLayoutSetBranches(layout.getGroupId(), layout.isPrivateLayout());
				%>

				<aui:select inlineField="<%= true %>" label="branch" name="layoutSetBranchId" id="layoutSetBranchId">

					<%
					for (LayoutSetBranch layoutSetBranch : branches) {
						boolean selected = false;

						if (layoutSetBranch.getLayoutSetBranchId() == layoutRevision.getLayoutSetBranchId()) {
							selected = true;
						}
					%>
						<aui:option label="<%= HtmlUtil.escape(layoutSetBranch.getName()) %>" selected="<%= selected %>" value="<%= layoutSetBranch.getLayoutSetBranchId() %>" />
					<%
					}
					%>

				</aui:select>
			</li>

			<c:if test="<%= !layoutRevision.isMajor() && (!layoutRevision.hasChildren()) && (layoutRevision.getParentLayoutRevisionId() != LayoutRevisionConstants.DEFAULT_PARENT_LAYOUT_REVISION_ID) %>">
				<li class="undo-revision" id="undoRevision">
					<a href="javascript:;">
						<liferay-ui:message key="undo" />
					</a>
				</li>
			</c:if>

			<li class="view-history" id="viewHistory">
				<a href="javascript:;">
					<liferay-ui:message key="history" />
				</a>
			</li>
			<li class="layout-revision-id-container" id="layoutRevisionIdContainer">
				[<span class="layout-revision-id-value"><%= layoutRevision.getLayoutRevisionId() %></span>]
			</li>
		</ul>
	</div>
</aui:form>

<aui:script position="inline" use="aui-dialog,aui-io-request,staging">
	Liferay.Staging.Dockbar.init();
</aui:script>