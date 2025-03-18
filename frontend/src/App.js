import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import HomePage from "./pages/HomePage";
import VotingPage from "./pages/VotingPage";
import CommentingPage from "./pages/CommentingPage";
import BestSpeakerVoting from "./pages/BestSpeakerVoting";
import BestEvaluatorVoting from "./pages/BestEvaluatorVoting";
import BestTableTopicVoting from "./pages/BestTableTopicVoting";

function App() {
  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li><Link to="/">Home</Link></li>
            <li>
              <Link to="/voting">Voting</Link>
              <ul>
                <li><Link to="/voting/best-speaker">Best Speaker</Link></li>
                <li><Link to="/voting/best-evaluator">Best Evaluator</Link></li>
                <li><Link to="/voting/best-table-topic">Best Table Topic</Link></li>
              </ul>
            </li>
            <li><Link to="/commenting">Commenting</Link></li>
          </ul>
        </nav>

        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/voting" element={<VotingPage />} />
          <Route path="/voting/best-speaker" element={<BestSpeakerVoting />} />
          <Route path="/voting/best-evaluator" element={<BestEvaluatorVoting />} />
          <Route path="/voting/best-table-topic" element={<BestTableTopicVoting />} />
          <Route path="/commenting" element={<CommentingPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
