<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Give Review - DocAid</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .rating {
            display: inline-block;
            border: none;
            direction: rtl;
        }
        .rating > input {
            display: none;
        }
        .rating > label {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
        }
        .rating > input:checked ~ label,
        .rating:not(:checked) > label:hover,
        .rating:not(:checked) > label:hover ~ label {
            color: #f7d106;
        }
    </style>
</head>
<body>
    <%@ include file="header_patient.jsp" %>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h1 class="card-title text-center">Write a Review</h1>
                        <p class="card-text text-center text-muted">Share your experience with Dr. ${param.doctorName}</p>
                        <form action="${pageContext.request.contextPath}/patient/submit-review" method="post" class="mt-4">
                            <input type="hidden" name="doctorId" value="${param.doctorId}">
                            <div class="mb-3">
                                <label class="form-label">Rating</label>
                                <div class="rating">
                                    <input type="radio" id="star5" name="rating" value="5" /><label for="star5" title="5 stars">★</label>
                                    <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="4 stars">★</label>
                                    <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="3 stars">★</label>
                                    <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="2 stars">★</label>
                                    <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="1 star">★</label>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="comment" class="form-label">Comment</label>
                                <textarea class="form-control" id="comment" name="comment" rows="5" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Submit Review</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>