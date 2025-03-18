import React, { useState } from 'react';
import { useParams, useHistory } from 'react-router-dom';
import '../styles/VotingForm.css';

const VotingForm = () => {
  const { category } = useParams();
  const history = useHistory();
  const [vote, setVote] = useState('');
  const [voted, setVoted] = useState(false);

  const handleChange = (e) => {
    setVote(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setVoted(true);
    alert(`You voted for: ${vote}`);
  };

  const handleBackToHome = () => {
    history.push('/');
  };

  return (
    <div className="voting-form-container">
      <h2>Vote for {category}</h2>
      <form onSubmit={handleSubmit}>
        <div className="input-group">
          <label>Enter Name</label>
          <input
            type="text"
            value={vote}
            onChange={handleChange}
            placeholder={`Enter ${category} Name`}
            required
          />
        </div>
        <button type="submit" className="submit-btn" disabled={voted}>
          {voted ? 'Vote Submitted' : 'Submit Vote'}
        </button>
      </form>

      {voted && (
        <div className="thank-you-message">
          <h3>Thank you for voting!</h3>
          <p>You voted for: {vote}</p>
          <button onClick={handleBackToHome}>Back to Home</button>
        </div>
      )}
    </div>
  );
};

export default VotingForm;
