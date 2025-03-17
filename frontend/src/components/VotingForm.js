import React, { useState } from 'react';

const VotingForm = () => {
  const [votes, setVotes] = useState({
    bestSpeaker: '',
    bestEvaluator: '',
    bestTableTopicMaster: ''
  });

  const [voted, setVoted] = useState(false);

  // Handle input change
  const handleChange = (e) => {
    const { name, value } = e.target;
    setVotes({
      ...votes,
      [name]: value
    });
  };

  // Handle form submission
  const handleSubmit = (e) => {
    e.preventDefault();
    setVoted(true);
    alert('Your vote has been submitted!');
  };

  return (
    <div>
      <h2>Vote for the following categories:</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Best Speaker: </label>
          <input
            type="text"
            name="bestSpeaker"
            value={votes.bestSpeaker}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Best Evaluator: </label>
          <input
            type="text"
            name="bestEvaluator"
            value={votes.bestEvaluator}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Best Table Topic Master: </label>
          <input
            type="text"
            name="bestTableTopicMaster"
            value={votes.bestTableTopicMaster}
            onChange={handleChange}
            required
          />
        </div>
        <button type="submit" disabled={voted}>
          {voted ? 'Vote Submitted' : 'Submit Vote'}
        </button>
      </form>

      {voted && (
        <div>
          <h3>Thank you for voting!</h3>
          <p>Your votes:</p>
          <ul>
            <li>Best Speaker: {votes.bestSpeaker}</li>
            <li>Best Evaluator: {votes.bestEvaluator}</li>
            <li>Best Table Topic Master: {votes.bestTableTopicMaster}</li>
          </ul>
        </div>
      )}
    </div>
  );
}

export default VotingForm;
