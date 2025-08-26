<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bookingModalLabel">Book Appointment with <span id="modalDoctorName"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="bookingForm" action="${pageContext.request.contextPath}/patient/book-appointment" method="post">
                    <input type="hidden" id="modalDoctorId" name="doctorId">
                    <div class="mb-3">
                        <h6>Doctor's Schedule</h6>
                        <ul id="doctorScheduleList" class="list-group">
                            <!-- Schedule will be populated by JavaScript -->
                        </ul>
                    </div>
                    <div class="mb-3">
                        <label for="appointmentDate" class="form-label">Select Date</label>
                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="appointmentTime" class="form-label">Select Time</label>
                        <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                    </div>
                    <div class="form-text">
                        Please select a date and time for your appointment.
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="bookingForm" class="btn btn-primary">Confirm Appointment</button>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var bookingModal = document.getElementById('bookingModal');
    bookingModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var doctorId = button.getAttribute('data-doctor-id');
        var doctorName = button.getAttribute('data-doctor-name');

        var modalDoctorId = bookingModal.querySelector('#modalDoctorId');
        var modalDoctorName = bookingModal.querySelector('#modalDoctorName');

        modalDoctorId.value = doctorId;
        modalDoctorName.textContent = doctorName;

        var doctorScheduleList = bookingModal.querySelector('#doctorScheduleList');
        doctorScheduleList.innerHTML = '<li class="list-group-item">Loading...</li>'; // Show loading indicator

        fetch('${pageContext.request.contextPath}/api/doctor-schedule?id=' + doctorId)
            .then(response => response.json())
            .then(data => {
                doctorScheduleList.innerHTML = ''; // Clear loading indicator
                if (data.length > 0) {
                    data.forEach(function (slot) {
                        var listItem = document.createElement('li');
                        listItem.className = 'list-group-item';
                        listItem.textContent = slot.day + ': ' + slot.startTime + ' - ' + slot.endTime;
                        doctorScheduleList.appendChild(listItem);
                    });
                } else {
                    var listItem = document.createElement('li');
                    listItem.className = 'list-group-item';
                    listItem.textContent = 'No schedule available.';
                    doctorScheduleList.appendChild(listItem);
                }
            })
            .catch(error => {
                console.error('Error fetching doctor schedule:', error);
                doctorScheduleList.innerHTML = '<li class="list-group-item text-danger">Could not load schedule.</li>';
            });
    });
});
</script>