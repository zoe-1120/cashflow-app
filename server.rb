#!/usr/bin/env ruby
require 'webrick'
require 'json'
require 'csv'
require 'date'

# Read the existing diagnostic dashboard HTML
BOSS_HTML_PATH = '/tmp/cashflow_server.rb'
boss_file_content = File.read(BOSS_HTML_PATH, encoding: 'UTF-8')
boss_data = boss_file_content.split('__END__')
BOSS_HTML = boss_data.length > 1 ? boss_data[1] : "<!-- Boss Dashboard not found -->"

# Initialize WEBrick server
server = WEBrick::HTTPServer.new(
  Port: 3456,
  Logger: WEBrick::Log.new('/dev/null'),
  AccessLog: []
)

# ============ HOME PAGE (Menu) ============
server.mount_proc('/') do |req, res|
  res.content_type = 'text/html;charset=utf-8'
  res.body = <<'HOME_HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cash Flow Dashboard Suite</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: linear-gradient(135deg, #0f1419 0%, #1a1f2e 100%);
      color: #e0e0e8;
      font-family: 'Segoe UI', Arial, sans-serif;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 20px;
    }
    .container {
      text-align: center;
      max-width: 800px;
    }
    .header {
      margin-bottom: 50px;
    }
    .logo {
      font-size: 48px;
      font-weight: 700;
      color: #d4af37;
      margin-bottom: 16px;
      letter-spacing: 2px;
    }
    .subtitle {
      font-size: 16px;
      color: #8a8a9a;
      margin-bottom: 8px;
    }
    .description {
      font-size: 13px;
      color: #6a6a7a;
      line-height: 1.6;
    }
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
      margin-top: 50px;
    }
    @media (max-width: 700px) {
      .dashboard-grid { grid-template-columns: 1fr; }
    }
    .dashboard-link {
      background: linear-gradient(135deg, #1a1f3a 0%, #10152d 100%);
      border: 2px solid #2a3050;
      border-radius: 12px;
      padding: 40px 30px;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: block;
    }
    .dashboard-link:hover {
      border-color: #d4af37;
      transform: translateY(-4px);
      box-shadow: 0 8px 32px rgba(212, 175, 55, 0.2);
    }
    .card-icon {
      font-size: 48px;
      margin-bottom: 16px;
    }
    .card-title {
      font-size: 22px;
      font-weight: 700;
      margin-bottom: 12px;
      color: #d4af37;
    }
    .card-desc {
      font-size: 13px;
      color: #8a8a9a;
      line-height: 1.6;
      margin-bottom: 20px;
    }
    .card-features {
      text-align: left;
      font-size: 12px;
      color: #6a6a7a;
      line-height: 1.8;
    }
    .feature {
      margin-bottom: 8px;
    }
    .cta-text {
      display: inline-block;
      margin-top: 20px;
      padding: 12px 32px;
      background: #d4af37;
      color: #0a0e27;
      border-radius: 6px;
      font-weight: 700;
      font-size: 13px;
    }
    .dashboard-link:hover .cta-text {
      background: #e0c055;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="header">
    <div class="logo">💰 CASH FLOW SUITE</div>
    <div class="subtitle">Financial Intelligence Platform</div>
    <div class="description">Choose your dashboard to analyze, monitor, and manage cash flow</div>
  </div>

  <div style="margin-bottom: 30px; text-align: center;">
    <a href="/import" style="display: inline-block; padding: 12px 24px; background: #d4af37; color: #0a0e27; border-radius: 6px; text-decoration: none; font-weight: 700; font-size: 14px; margin-bottom: 20px;">
      📥 导入财务数据 · IMPORT DATA
    </a>
  </div>

  <div class="dashboard-grid">
    <!-- Executive Dashboard -->
    <a href="/boss" class="dashboard-link">
      <div class="card-icon">📊</div>
      <div class="card-title">Executive Dashboard</div>
      <div class="card-desc">Comprehensive financial diagnostic report</div>
      <div class="card-features">
        <div class="feature">✓ 7-tab analysis (Overview, Cash Flow, WC, P&L, Debt, Actions)</div>
        <div class="feature">✓ Multi-year comparisons & trends</div>
        <div class="feature">✓ Deep diagnostic insights & recommendations</div>
        <div class="feature">✓ Real-time input & scenario modeling</div>
      </div>
      <div class="cta-text">→ LAUNCH</div>
    </a>

    <!-- Internal Monitor -->
    <a href="/monitor" class="dashboard-link">
      <div class="card-icon">⚡</div>
      <div class="card-title">Live Cash Monitor</div>
      <div class="card-desc">Real-time monitoring with file uploads</div>
      <div class="card-features">
        <div class="feature">✓ Upload bank transactions (CSV/Excel)</div>
        <div class="feature">✓ Daily cash balance tracking</div>
        <div class="feature">✓ Live KPIs & cash runway forecast</div>
        <div class="feature">✓ Transaction categorization</div>
      </div>
      <div class="cta-text">→ LAUNCH</div>
    </a>
  </div>
</div>

</body>
</html>
HOME_HTML
end

# ============ BOSS DASHBOARD (Diagnostic) ============
server.mount_proc('/boss') do |req, res|
  res.content_type = 'text/html;charset=utf-8'
  res.body = BOSS_HTML
end

# ============ MONITOR DASHBOARD (Internal Live Monitor) ============
server.mount_proc('/monitor') do |req, res|
  res.content_type = 'text/html;charset=utf-8'
  res.body = <<'MONITOR_HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Live Cash Flow Monitor - Internal</title>
  <style>
    :root {
      --bg: #0a0e27;
      --bg2: #10152d;
      --card: #1a1f3a;
      --border: #2a3050;
      --text: #e0e0e8;
      --muted: #8a8a9a;
      --green: #4eca6d;
      --red: #ff5757;
      --amber: #ffa500;
      --gold: #d4af37;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'Monaco', 'Menlo', monospace;
      font-size: 13px;
      line-height: 1.5;
    }
    .header {
      background: linear-gradient(135deg, #0a0e27, #10152d);
      border-bottom: 2px solid var(--gold);
      padding: 14px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .logo {
      font-size: 16px;
      font-weight: 700;
      color: var(--gold);
      letter-spacing: 2px;
    }
    .home-link {
      padding: 8px 16px;
      background: var(--border);
      border-radius: 4px;
      text-decoration: none;
      color: var(--text);
      font-size: 12px;
      transition: all 0.3s;
    }
    .home-link:hover {
      background: var(--gold);
      color: var(--bg);
    }
    .upload-zone {
      padding: 20px;
      max-width: 1200px;
      margin: 0 auto;
    }
    .drop-area {
      border: 2px dashed var(--border);
      border-radius: 8px;
      padding: 30px;
      text-align: center;
      background: var(--card);
      cursor: pointer;
      transition: all 0.3s;
    }
    .drop-area.hover {
      border-color: var(--gold);
      background: #1a2545;
    }
    .drop-area input {
      display: none;
    }
    .drop-area p {
      margin: 8px 0;
    }
    .dashboard {
      padding: 20px;
      max-width: 1400px;
      margin: 0 auto;
      display: none;
    }
    .dashboard.active {
      display: block;
    }
    .top-row {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
      margin-bottom: 20px;
    }
    .kpi {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 16px;
      text-align: center;
    }
    .kpi-label {
      font-size: 11px;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 8px;
    }
    .kpi-value {
      font-size: 32px;
      font-weight: 700;
      font-variant-numeric: tabular-nums;
      margin-bottom: 4px;
    }
    .kpi-change {
      font-size: 12px;
    }
    .kpi-change.pos {
      color: var(--green);
    }
    .kpi-change.neg {
      color: var(--red);
    }
    .charts {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
    }
    .chart-box {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 16px;
    }
    .chart-title {
      font-size: 12px;
      font-weight: 700;
      color: var(--gold);
      margin-bottom: 12px;
      text-transform: uppercase;
    }
    svg {
      width: 100%;
      height: 200px;
    }
    .transactions {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 8px;
      overflow: hidden;
      margin-top: 20px;
    }
    .tx-header {
      background: var(--bg2);
      padding: 12px 16px;
      border-bottom: 1px solid var(--border);
      font-weight: 700;
      font-size: 12px;
    }
    .tx-row {
      padding: 12px 16px;
      border-bottom: 1px solid var(--border);
      display: grid;
      grid-template-columns: 100px 1fr 120px 120px;
      gap: 12px;
      align-items: center;
    }
    .tx-row:last-child {
      border-bottom: none;
    }
    .tx-in {
      color: var(--green);
    }
    .tx-out {
      color: var(--red);
    }
    .tx-date {
      font-family: monospace;
      color: var(--muted);
      font-size: 11px;
    }
    .forecast-box {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 16px;
      margin-top: 20px;
    }
    .forecast-title {
      font-size: 12px;
      font-weight: 700;
      color: var(--gold);
      margin-bottom: 12px;
    }
    .forecast-item {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid var(--border);
      font-size: 12px;
    }
    .forecast-item:last-child {
      border-bottom: none;
    }
    .forecast-label {
      color: var(--muted);
    }
    .forecast-val {
      font-family: monospace;
      font-weight: 600;
    }
    .warning {
      background: #2a0000;
      border-left: 3px solid var(--red);
      padding: 8px 12px;
      margin-bottom: 12px;
      font-size: 12px;
      color: #ff9999;
    }
    .success {
      background: #002a00;
      border-left: 3px solid var(--green);
      padding: 8px 12px;
      margin-bottom: 12px;
      font-size: 12px;
      color: #99ff99;
    }
    @media(max-width: 900px) {
      .top-row { grid-template-columns: repeat(2, 1fr); }
      .charts { grid-template-columns: 1fr; }
      .tx-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<div class="header">
  <div class="logo">⚡ LIVE CASH FLOW MONITOR</div>
  <a href="/" class="home-link">← Back to Home</a>
</div>

<div class="upload-zone">
  <div class="drop-area" id="dropZone">
    <p style="margin-bottom: 8px; font-weight: 700;">📤 Drag & Drop transaction file here</p>
    <p style="font-size: 11px; color: var(--muted);">CSV format: Date | Description | Amount | Type</p>
    <p style="font-size: 11px; color: var(--muted); margin-top: 4px;">Or click to browse</p>
    <input type="file" id="fileInput" accept=".csv,.xlsx">
  </div>
</div>

<div class="dashboard" id="dashboard">
  <div class="top-row">
    <div class="kpi">
      <div class="kpi-label">💰 Current Balance</div>
      <div class="kpi-value" id="kpi-balance">0</div>
      <div class="kpi-change" id="kpi-balance-chg">—</div>
    </div>
    <div class="kpi">
      <div class="kpi-label">📈 Today Inflow</div>
      <div class="kpi-value pos" id="kpi-inflow">0</div>
      <div class="kpi-change">Receipts</div>
    </div>
    <div class="kpi">
      <div class="kpi-label">📉 Today Outflow</div>
      <div class="kpi-value neg" id="kpi-outflow">0</div>
      <div class="kpi-change">Payments</div>
    </div>
    <div class="kpi">
      <div class="kpi-label">📊 Net Change</div>
      <div class="kpi-value" id="kpi-net">0</div>
      <div class="kpi-change" id="kpi-net-chg">—</div>
    </div>
  </div>

  <div class="charts">
    <div class="chart-box">
      <div class="chart-title">Daily Cash Flow Waterfall (7 days)</div>
      <svg id="chart-waterfall"></svg>
    </div>
    <div class="chart-box">
      <div class="chart-title">Balance Trend</div>
      <svg id="chart-trend"></svg>
    </div>
  </div>

  <div class="forecast-box">
    <div class="forecast-title">💡 Cash Runway Forecast</div>
    <div id="forecast-items"></div>
  </div>

  <div class="transactions">
    <div class="tx-header">Recent Transactions</div>
    <div id="tx-list"></div>
  </div>
</div>

<script>
const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('fileInput');
const dashboard = document.getElementById('dashboard');

let CASH_DATA = {
  balance: 0,
  transactions: [],
  daily_burn: 5000
};

function formatCash(v) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'MYR', minimumFractionDigits: 0 }).format(v);
}

function render() {
  const today = new Date().toISOString().split('T')[0];
  const todayTxs = CASH_DATA.transactions.filter(t => t.date === today);
  const todayInflow = todayTxs.filter(t => t.type === 'in').reduce((s, t) => s + t.amount, 0);
  const todayOutflow = todayTxs.filter(t => t.type === 'out').reduce((s, t) => s + t.amount, 0);
  const netChange = todayInflow - todayOutflow;

  document.getElementById('kpi-balance').textContent = formatCash(CASH_DATA.balance);
  document.getElementById('kpi-inflow').textContent = formatCash(todayInflow);
  document.getElementById('kpi-outflow').textContent = formatCash(todayOutflow);
  document.getElementById('kpi-net').textContent = formatCash(netChange);
  document.getElementById('kpi-net-chg').textContent = (netChange >= 0 ? '+' : '') + formatCash(netChange);
  document.getElementById('kpi-net-chg').className = 'kpi-change ' + (netChange >= 0 ? 'pos' : 'neg');

  // Transactions list
  let txHtml = '';
  CASH_DATA.transactions.slice(-20).reverse().forEach(tx => {
    txHtml += '<div class="tx-row">' +
      '<div class="tx-date">' + tx.date + '</div>' +
      '<div>' + tx.desc + '</div>' +
      '<div class="' + (tx.type === 'in' ? 'tx-in' : 'tx-out') + '">' + formatCash(tx.amount) + '</div>' +
      '<div style="text-align:right;font-size:10px;color:var(--muted)">' + (tx.type === 'in' ? 'In' : 'Out') + '</div>' +
      '</div>';
  });
  document.getElementById('tx-list').innerHTML = txHtml;

  // Forecast
  const runwayDays = Math.floor(CASH_DATA.balance / CASH_DATA.daily_burn);
  const zeroDate = new Date(Date.now() + runwayDays * 86400000).toLocaleDateString();
  const forecastHtml = '<div class="' + (runwayDays > 30 ? 'success' : 'warning') + '">' +
    (runwayDays > 30 ? '✅ Runway: ' : '⚠️ Runway: ') + runwayDays + ' days at current burn rate</div>' +
    '<div class="forecast-item">' +
      '<span class="forecast-label">Current Balance</span>' +
      '<span class="forecast-val">' + formatCash(CASH_DATA.balance) + '</span>' +
    '</div>' +
    '<div class="forecast-item">' +
      '<span class="forecast-label">Avg Daily Burn</span>' +
      '<span class="forecast-val">' + formatCash(CASH_DATA.daily_burn) + '</span>' +
    '</div>' +
    '<div class="forecast-item">' +
      '<span class="forecast-label">Zero Cash Date</span>' +
      '<span class="forecast-val">' + zeroDate + '</span>' +
    '</div>';
  document.getElementById('forecast-items').innerHTML = forecastHtml;

  dashboard.classList.add('active');
}

dropZone.addEventListener('click', () => fileInput.click());
dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.classList.add('hover'); });
dropZone.addEventListener('dragleave', () => dropZone.classList.remove('hover'));
dropZone.addEventListener('drop', e => {
  e.preventDefault();
  dropZone.classList.remove('hover');
  handleFiles(e.dataTransfer.files);
});
fileInput.addEventListener('change', e => handleFiles(e.target.files));

function handleFiles(files) {
  if (!files.length) return;
  const file = files[0];
  const reader = new FileReader();
  reader.onload = e => {
    const csv = e.target.result;
    const lines = csv.split('\n');
    const headers = lines[0].split(',');
    const transactions = [];

    for (let i = 1; i < lines.length; i++) {
      if (!lines[i].trim()) continue;
      const cells = lines[i].split(',');
      const date = cells[0] ? cells[0].trim() : '';
      const desc = cells[1] ? cells[1].trim() : '';
      const amount = parseFloat(cells[2]);
      const type = cells[3] ? (cells[3].toLowerCase().includes('in') ? 'in' : 'out') : (amount >= 0 ? 'in' : 'out');

      if (date && !isNaN(amount)) {
        transactions.push({ date, desc, amount: Math.abs(amount), type });
      }
    }

    CASH_DATA.transactions = transactions.sort((a, b) => new Date(a.date) - new Date(b.date));

    // Calculate cumulative balance
    let cumBalance = 0;
    CASH_DATA.transactions.forEach(tx => {
      if (tx.type === 'in') cumBalance += tx.amount;
      else cumBalance -= tx.amount;
    });
    CASH_DATA.balance = cumBalance;

    // Calculate daily burn rate
    const dates = [...new Set(CASH_DATA.transactions.map(t => t.date))];
    if (dates.length > 1) {
      const dailyNetChanges = [];
      dates.forEach(date => {
        const dayTxs = CASH_DATA.transactions.filter(t => t.date === date);
        const dayNet = dayTxs.filter(t => t.type === 'in').reduce((s, t) => s + t.amount, 0) -
                      dayTxs.filter(t => t.type === 'out').reduce((s, t) => s + t.amount, 0);
        dailyNetChanges.push(Math.abs(dayNet));
      });
      CASH_DATA.daily_burn = dailyNetChanges.reduce((a, b) => a + b, 0) / dates.length;
    }

    render();
  };
  reader.readAsText(file);
}

// Sample data for demo
CASH_DATA.transactions = [
  { date: '2026-06-28', desc: 'Opening Balance', amount: 450000, type: 'in' },
  { date: '2026-06-29', desc: 'Sales - Client A', amount: 25000, type: 'in' },
  { date: '2026-06-29', desc: 'Payroll', amount: 18000, type: 'out' },
  { date: '2026-06-29', desc: 'Supplier Payment', amount: 12500, type: 'out' },
  { date: '2026-06-30', desc: 'Sales - Client B', amount: 32000, type: 'in' },
  { date: '2026-06-30', desc: 'Rent', amount: 8000, type: 'out' },
  { date: '2026-06-30', desc: 'Utilities', amount: 2500, type: 'out' }
];
CASH_DATA.balance = 457000;
render();
</script>
</body>
</html>
MONITOR_HTML
end

# ============ IMPORT DATA (File Upload & Parsing) ============
server.mount_proc('/import') do |req, res|
  res.content_type = 'text/html;charset=utf-8'
  import_file = File.read('./import.html', encoding: 'UTF-8') rescue '<h1>import.html not found</h1>'
  res.body = import_file
end

# ============ FILE UPLOAD API ============
server.mount_proc('/api/upload') do |req, res|
  res.content_type = 'application/json;charset=utf-8'

  if req.request_method == 'POST' && req.query && req.query['file']
    file_data = req.query['file']
    filename = file_data.filename
    file_content = file_data.read

    case File.extname(filename).downcase
    when '.csv'
      result = parse_csv(file_content)
      res.body = result.to_json
    when '.xlsx', '.xls'
      res.body = { error: 'Excel parsing: Please convert to CSV first' }.to_json
    when '.pdf'
      res.body = { error: 'PDF parsing: Please extract transactions to CSV' }.to_json
    else
      res.body = { error: 'Unsupported format. Use CSV, Excel, or PDF.' }.to_json
    end
  else
    res.body = { error: 'POST request required' }.to_json
  end
end

# ============ CSV PARSER ============
def parse_csv(file_content)
  transactions = []
  begin
    csv = CSV.parse(file_content.force_encoding('utf-8'), headers: true)
    csv.each do |row|
      next if row.values.all?(&:nil?)

      date_val = row['Date'] || row['date'] || row['DATE'] || row['日期']
      desc_val = row['Description'] || row['description'] || row['DESCRIPTION'] || row['描述']
      amt_val = row['Amount'] || row['amount'] || row['AMOUNT'] || row['金额']
      type_val = row['Type'] || row['type'] || row['TYPE'] || row['类型']

      next unless date_val && amt_val

      begin
        date = Date.parse(date_val.to_s)
      rescue
        next
      end

      amount = amt_val.to_f
      tx_type = if type_val
        type_val.to_s.downcase.include?('in') || type_val.to_s.downcase.include?('入') ? 'in' : 'out'
      else
        amount >= 0 ? 'in' : 'out'
      end

      transactions << {
        date: date.to_s,
        desc: desc_val.to_s.strip,
        amount: amount.abs,
        type: tx_type
      }
    end

    transactions.sort_by! { |t| t[:date] }

    today = Date.today.to_s
    today_txs = transactions.select { |t| t[:date] == today }
    today_inflow = today_txs.select { |t| t[:type] == 'in' }.sum { |t| t[:amount] }
    today_outflow = today_txs.select { |t| t[:type] == 'out' }.sum { |t| t[:amount] }

    {
      success: true,
      transactions: transactions,
      summary: {
        total_transactions: transactions.length,
        today_inflow: today_inflow,
        today_outflow: today_outflow,
        today_net: today_inflow - today_outflow
      }
    }
  rescue => e
    { success: false, error: "Parse error: #{e.message}" }
  end
end

# Start the server
trap('INT') { server.shutdown }
server.start
