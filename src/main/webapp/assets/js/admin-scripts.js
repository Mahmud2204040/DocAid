/*!
 * Custom scripts for the DocAid Admin Dashboard
 */

window.addEventListener('DOMContentLoaded', event => {

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('toggled');
        });
    }

    // Logic for Delete User Modal
    const deleteUserModal = document.getElementById('deleteUserModal');
    if (deleteUserModal) {
        deleteUserModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const userId = button.getAttribute('data-userid');
            const userName = button.getAttribute('data-username');
            
            deleteUserModal.querySelector('#deleteUserName').textContent = userName;
            deleteUserModal.querySelector('#deleteUserId').value = userId;
        });
    }

    // Logic for Stop Monitoring Modal
    const stopMonitorModal = document.getElementById('stopMonitorModal');
    if (stopMonitorModal) {
        stopMonitorModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const monitorId = button.getAttribute('data-monitorid');
            const userEmail = button.getAttribute('data-useremail');

            stopMonitorModal.querySelector('#stopMonitorUserEmail').textContent = userEmail;
            stopMonitorModal.querySelector('#stopMonitorId').value = monitorId;
        });
    }

    // Logic for Edit Specialty Modal
    const editSpecialtyModal = document.getElementById('editSpecialtyModal');
    if (editSpecialtyModal) {
        editSpecialtyModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const specialtyId = button.getAttribute('data-specialtyid');
            const specialtyName = button.getAttribute('data-specialtyname');

            editSpecialtyModal.querySelector('#editSpecialtyId').value = specialtyId;
            editSpecialtyModal.querySelector('#editSpecialtyName').value = specialtyName;
        });
    }

    // Logic for Delete Specialty Modal
    const deleteSpecialtyModal = document.getElementById('deleteSpecialtyModal');
    if (deleteSpecialtyModal) {
        deleteSpecialtyModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const specialtyId = button.getAttribute('data-specialtyid');
            const specialtyName = button.getAttribute('data-specialtyname');

            deleteSpecialtyModal.querySelector('#deleteSpecialtyName').textContent = specialtyName;
            deleteSpecialtyModal.querySelector('#deleteSpecialtyId').value = specialtyId;
        });
    }
});
