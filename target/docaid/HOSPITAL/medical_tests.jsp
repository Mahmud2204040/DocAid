<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="tests" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<%-- Main Content --%>
<h1 class="mb-4">Medical Test Catalog</h1>

<%-- Display feedback message if it exists --%>
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        <c:out value="${sessionScope.message}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
    <% session.removeAttribute("messageClass"); %>
</c:if>

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">Available Medical Tests</h6>
        <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addTestModal">
            <i class="fas fa-plus"></i> Add New Test
        </button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-hover" id="testsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Test Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="test" items="${testList}">
                        <tr>
                            <td><c:out value="${test.testName}"/></td>
                            <td><c:out value="${test.description}"/></td>
                            <td>$<c:out value="${String.format('%.2f', test.price)}"/></td>
                            <td>
                                <c:if test="${test.active}">
                                    <span class="badge bg-success">Active</span>
                                </c:if>
                                <c:if test="${!test.active}">
                                    <span class="badge bg-secondary">Inactive</span>
                                </c:if>
                            </td>
                            <td>
                                <button type="button" class="btn btn-sm btn-warning edit-btn" 
                                        data-bs-toggle="modal" data-bs-target="#editTestModal"
                                        data-test-id="${test.testId}"
                                        data-test-name="${test.testName}"
                                        data-test-price="${test.price}"
                                        data-test-description="${test.description}">Edit</button>
                                <button type="button" class="btn btn-sm btn-danger delete-btn"
                                        data-bs-toggle="modal" data-bs-target="#deleteTestModal"
                                        data-test-id="${test.testId}"
                                        data-test-name="${test.testName}">Delete</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty testList}">
                        <tr>
                            <td colspan="5" class="text-center">No medical tests found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />

<!-- Add Test Modal -->
<div class="modal fade" id="addTestModal" tabindex="-1" aria-labelledby="addTestModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/hospital/medical-tests" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTestModalLabel">Add New Medical Test</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="add_test_name" class="form-label">Test Name</label>
                        <input type="text" class="form-control" id="add_test_name" name="test_name" required>
                    </div>
                    <div class="mb-3">
                        <label for="add_price" class="form-label">Price</label>
                        <input type="number" class="form-control" id="add_price" name="price" step="0.01" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label for="add_description" class="form-label">Description</label>
                        <textarea class="form-control" id="add_description" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Test</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Test Modal -->
<div class="modal fade" id="editTestModal" tabindex="-1" aria-labelledby="editTestModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/hospital/medical-tests" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="editTestModalLabel">Edit Medical Test</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="edit_test_id" name="test_id">
                    <div class="mb-3">
                        <label for="edit_test_name" class="form-label">Test Name</label>
                        <input type="text" class="form-control" id="edit_test_name" name="test_name" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit_price" class="form-label">Price</label>
                        <input type="number" class="form-control" id="edit_price" name="price" step="0.01" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit_description" class="form-label">Description</label>
                        <textarea class="form-control" id="edit_description" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteTestModal" tabindex="-1" aria-labelledby="deleteTestModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/hospital/medical-tests" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteTestModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="delete_test_id" name="test_id">
                    <input type="hidden" name="action" value="delete">
                    <p>Are you sure you want to delete the test: <strong id="delete_test_name"></strong>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete Test</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // Logic for populating the Edit modal
    var editTestModal = document.getElementById('editTestModal');
    if(editTestModal) {
        editTestModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var testId = button.getAttribute('data-test-id');
            var testName = button.getAttribute('data-test-name');
            var testPrice = button.getAttribute('data-test-price');
            var testDescription = button.getAttribute('data-test-description');
            editTestModal.querySelector('#edit_test_id').value = testId;
            editTestModal.querySelector('#edit_test_name').value = testName;
            editTestModal.querySelector('#edit_price').value = testPrice;
            editTestModal.querySelector('#edit_description').value = testDescription;
        });
    }

    // Logic for populating the Delete modal
    var deleteTestModal = document.getElementById('deleteTestModal');
    if(deleteTestModal) {
        deleteTestModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var testId = button.getAttribute('data-test-id');
            var testName = button.getAttribute('data-test-name');
            deleteTestModal.querySelector('#delete_test_id').value = testId;
            deleteTestModal.querySelector('#delete_test_name').textContent = testName;
        });
    }
});
</script>