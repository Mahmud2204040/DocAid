<!-- Delete User Confirmation Modal -->
<div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteUserModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="userId" id="deleteUserId">
                    <p>Are you sure you want to permanently delete the user: <strong id="deleteUserName"></strong>?</p>
                    <p class="text-danger"><small>This action cannot be undone.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Stop Monitoring Confirmation Modal -->
<div class="modal fade" id="stopMonitorModal" tabindex="-1" aria-labelledby="stopMonitorModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="stopMonitorModalLabel">Confirm Stop Monitoring</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/monitoring" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="stop">
                    <input type="hidden" name="monitorId" id="stopMonitorId">
                    <p>Are you sure you want to stop the monitoring session for user: <strong id="stopMonitorUserEmail"></strong>?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Stop Monitoring</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Specialty Modal -->
<div class="modal fade" id="editSpecialtyModal" tabindex="-1" aria-labelledby="editSpecialtyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editSpecialtyModalLabel">Edit Specialty</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/specialties" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="specialtyId" id="editSpecialtyId">
                    <div class="mb-3">
                        <label for="editSpecialtyName" class="form-label">Specialty Name</label>
                        <input type="text" class="form-control" id="editSpecialtyName" name="newSpecialtyName" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Specialty Confirmation Modal -->
<div class="modal fade" id="deleteSpecialtyModal" tabindex="-1" aria-labelledby="deleteSpecialtyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteSpecialtyModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/specialties" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="specialtyId" id="deleteSpecialtyId">
                    <p>Are you sure you want to delete the specialty: <strong id="deleteSpecialtyName"></strong>?</p>
                    <p class="text-danger"><small>This may affect existing doctors associated with this specialty.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete Specialty</button>
                </div>
            </form>
        </div>
    </div>
</div>
