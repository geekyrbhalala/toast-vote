import { Link } from "react-router-dom";

const VotingPage = () => {
  return (
    <div>
      <h1>Voting</h1>
      <p>Select a category to vote:</p>
      <ul>
        <li><Link to="/voting/best-speaker">Best Speaker</Link></li>
        <li><Link to="/voting/best-evaluator">Best Evaluator</Link></li>
        <li><Link to="/voting/best-table-topic">Best Table Topic Master</Link></li>
      </ul>
    </div>
  );
};

export default VotingPage;
