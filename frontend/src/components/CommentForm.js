import React, { useState } from 'react';
import { useParams, useHistory } from 'react-router-dom';
import '../styles/CommentForm.css';

const CommentForm = () => {
  const { category } = useParams();
  const history = useHistory();
  const [comment, setComment] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleChange = (e) => {
    setComment(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setSubmitted(true);
    alert(`Your comment has been submitted for: ${category}`);
  };

  const handleBackToHome = () => {
    history.push('/');
  };

  return (
    <div className="comment-form-container">
      <h2>Leave a Comment for {category}</h2>
      <form onSubmit={handleSubmit}>
        <div className="input-group">
          <label>Enter Your Comment</label>
          <textarea
            value={comment}
            onChange={handleChange}
            placeholder={`Enter comment for ${category}`}
            required
          ></textarea>
        </div>
        <button type="submit" className="submit-btn" disabled={submitted}>
          {submitted ? 'Comment Submitted' : 'Submit Comment'}
        </button>
      </form>

      {submitted && (
        <div className="thank-you-message">
          <h3>Thank you for your comment!</h3>
          <p>Your comment: {comment}</p>
          <button onClick={handleBackToHome}>Back to Home</button>
        </div>
      )}
    </div>
  );
};

export default CommentForm;
