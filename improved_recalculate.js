  const cash = parseFloat(document.getElementById('input-cash').value) || 0;
  const rec = parseFloat(document.getElementById('input-rec').value) || 0;
  const inv = parseFloat(document.getElementById('input-inv').value) || 0;
  const pay = parseFloat(document.getElementById('input-pay').value) || 0;
  const stl = parseFloat(document.getElementById('input-stl').value) || 0;
  const od = parseFloat(document.getElementById('input-od').value) || 0;
  const ltl = parseFloat(document.getElementById('input-ltl').value) || 0;
  const rev = parseFloat(document.getElementById('input-rev').value) || 0;
  const cogs = parseFloat(document.getElementById('input-cogs').value) || 0;
  const opex = parseFloat(document.getElementById('input-opex').value) || 0;
  const fin = parseFloat(document.getElementById('input-fin').value) || 0;

  const netCash = cash - od;
  const gp = rev - cogs;
  const npm = rev > 0 ? (gp / rev) : 0;
  const netProfit = rev - cogs - opex - fin;
  const monthlyLoss = Math.max(0, -netProfit);
  const totalDebt = stl + od + ltl;
  const debtRatio = rev > 0 ? (totalDebt / rev) : 0;

  // 更新所有 KPI
  const kpiCash = document.getElementById('kpi-cash');
  kpiCash.textContent = '¥' + netCash.toFixed(0);
  kpiCash.style.color = netCash >= 0 ? 'var(--green)' : 'var(--red)';
  
  document.getElementById('kpi-loss').textContent = '¥' + monthlyLoss.toFixed(0);
  document.getElementById('kpi-equity').textContent = '¥' + (cash + rec + inv - pay - stl - od - ltl).toFixed(0);
  document.getElementById('kpi-margin').textContent = (npm * 100).toFixed(1) + '%';
  document.getElementById('kpi-cycle').textContent = '—';

  // 更新 CASH FLOW
  document.getElementById('cf-start').textContent = '¥' + cash.toFixed(0);
  document.getElementById('cf-op').textContent = (netProfit >= 0 ? '+' : '') + '¥' + netProfit.toFixed(0);
  document.getElementById('cf-wc').textContent = '¥' + ((rec + inv - pay) / 12).toFixed(0);
  document.getElementById('cf-end').textContent = '¥' + netCash.toFixed(0);

  // 更新 WORKING CAPITAL
  const recDays = rev > 0 ? (rec / (rev / 30)) : 0;
  const invDays = cogs > 0 ? (inv / (cogs / 30)) : 0;
  const payDays = cogs > 0 ? (pay / (cogs / 30)) : 0;
  const cycle = recDays + invDays - payDays;

  document.getElementById('wc-rec').textContent = recDays.toFixed(0);
  document.getElementById('wc-inv').textContent = invDays.toFixed(0);
  document.getElementById('wc-pay').textContent = payDays.toFixed(0);
  document.getElementById('wc-cycle').textContent = cycle.toFixed(0);
  document.getElementById('wc-cycle').style.color = cycle < 0 ? 'var(--green)' : 'var(--red)';

  // 更新 P&L
  document.getElementById('pl-rev').textContent = '¥' + rev.toFixed(0);
  document.getElementById('pl-cogs').textContent = '¥' + cogs.toFixed(0);
  document.getElementById('pl-cogs-pct').textContent = rev > 0 ? (cogs/rev*100).toFixed(0) + '%' : '—';
  document.getElementById('pl-gp').textContent = '¥' + gp.toFixed(0);
  document.getElementById('pl-gp-pct').textContent = rev > 0 ? (gp/rev*100).toFixed(0) + '%' : '—';
  document.getElementById('pl-opex').textContent = '¥' + opex.toFixed(0);
  document.getElementById('pl-opex-pct').textContent = rev > 0 ? (opex/rev*100).toFixed(0) + '%' : '—';
  document.getElementById('pl-net').textContent = '¥' + netProfit.toFixed(0);
  document.getElementById('pl-net-pct').textContent = rev > 0 ? (netProfit/rev*100).toFixed(1) + '%' : '—';
  document.getElementById('pl-net').style.color = netProfit >= 0 ? 'var(--green)' : 'var(--red)';

  // 更新 DEBT
  document.getElementById('debt-st').textContent = '¥' + stl.toFixed(0);
  document.getElementById('debt-od').textContent = '¥' + od.toFixed(0);
  document.getElementById('debt-lt').textContent = '¥' + ltl.toFixed(0);
  document.getElementById('debt-total').textContent = '¥' + totalDebt.toFixed(0);

  // ============ 关键：生成详细分析 ============
  const insights = [];
  
  // 现金流分析
  if (netCash < 0) {
    insights.push({
      level: 'critical',
      title: '🔴 现金告急',
      detail: `净现金为负 ¥${netCash.toFixed(0)}，公司现金不足。按当前每月亏损 ¥${monthlyLoss.toFixed(0)} 计算，剩余现金只能维持 ${Math.abs(netCash / monthlyLoss).toFixed(1)} 个月。`
    });
  } else if (netCash < rev / 3) {
    insights.push({
      level: 'warning',
      title: '⚠️ 现金储备不足',
      detail: `净现金 ¥${netCash.toFixed(0)} 低于月收入的 1/3。建议保持至少 3 个月的运营资金储备。`
    });
  }

  // 盈利性分析
  if (npm < 0.1) {
    insights.push({
      level: 'critical',
      title: '🔴 毛利率极低',
      detail: `毛利率仅 ${(npm*100).toFixed(1)}%，远低于 30% 的行业标准。需要立即：①提高销售价格 或 ②降低采购成本，否则无法承担固定费用。`
    });
  } else if (npm < 0.3) {
    insights.push({
      level: 'warning',
      title: '⚠️ 毛利率偏低',
      detail: `毛利率 ${(npm*100).toFixed(1)}% 处于危险线。每增加 ¥1M 收入，只能贡献 ¥${(npm*1000000).toFixed(0)} 毛利，难以覆盖运营费用。`
    });
  }

  // 亏损分析
  if (netProfit < 0) {
    const monthsOfCash = netCash > 0 ? (netCash / monthlyLoss).toFixed(1) : 0;
    insights.push({
      level: 'critical',
      title: '🔴 严重亏损',
      detail: `月度亏损 ¥${monthlyLoss.toFixed(0)}，年度预计亏损 ¥${(monthlyLoss*12).toFixed(0)}。${netCash > 0 ? `按当前现金 ¥${netCash.toFixed(0)}，还能维持 ${monthsOfCash} 个月。` : '现金已用尽，需要融资。'}`
    });
  } else {
    insights.push({
      level: 'good',
      title: '✅ 盈利',
      detail: `月度净利 ¥${netProfit.toFixed(0)}，年度预计利润 ¥${(netProfit*12).toFixed(0)}。继续保持。`
    });
  }

  // 工作资本分析
  if (cycle > 100) {
    insights.push({
      level: 'critical',
      title: '🔴 现金周期过长',
      detail: `现金周期 ${cycle.toFixed(0)} 天（应收 ${recDays.toFixed(0)}天 + 库存 ${invDays.toFixed(0)}天 - 应付 ${payDays.toFixed(0)}天）。每多占 1 天，就冻结 ¥${(rev/30).toFixed(0)} 现金。建议加快应收回收或减少库存。`
    });
  }

  // 应收分析
  if (recDays > 60) {
    insights.push({
      level: 'warning',
      title: '⚠️ 应收周期过长',
      detail: `客户平均 ${recDays.toFixed(0)} 天才支付，行业标准是 30-45 天。缩短 10 天可释放现金 ¥${(rec * 10 / recDays).toFixed(0)}。`
    });
  }

  // 库存分析
  if (invDays > 90) {
    insights.push({
      level: 'critical',
      title: '🔴 库存占用资金过多',
      detail: `库存周期 ${invDays.toFixed(0)} 天，库存占用资金 ¥${inv.toFixed(0)}。若减少 20%，可释放 ¥${(inv*0.2).toFixed(0)} 现金。建议优化库存管理。`
    });
  }

  // 债务分析
  if (debtRatio > 2) {
    insights.push({
      level: 'critical',
      title: '🔴 债务过高',
      detail: `总债务 ¥${totalDebt.toFixed(0)}，是年收入的 ${debtRatio.toFixed(1)}x。债务偿付能力弱，需要优先还款。`
    });
  } else if (od > 0) {
    insights.push({
      level: 'warning',
      title: '⚠️ 有银行透支',
      detail: `银行透支 ¥${od.toFixed(0)}，这是最昂贵的融资方式（利息 10%+）。应优先还清。`
    });
  }

  // 生成 HTML 显示所有分析
  let analysisHTML = '<div style="margin-top: 20px;">';
  insights.forEach(insight => {
    const bgColor = insight.level === 'critical' ? '#1a0505' : (insight.level === 'warning' ? '#1a1000' : '#001a0e');
    const borderColor = insight.level === 'critical' ? 'var(--red)' : (insight.level === 'warning' ? '#ff9800' : 'var(--green)');
    const titleColor = insight.level === 'critical' ? 'var(--red)' : (insight.level === 'warning' ? '#ff9800' : 'var(--green)');
    
    analysisHTML += `
      <div style="background: ${bgColor}; border-left: 3px solid ${borderColor}; padding: 12px; margin-bottom: 12px; border-radius: 4px;">
        <strong style="color: ${titleColor};">${insight.title}</strong><br>
        <span style="font-size: 12px; color: var(--text); line-height: 1.5;">${insight.detail}</span>
      </div>
    `;
  });
  analysisHTML += '</div>';

  // 显示分析
  const analysisContainer = document.getElementById('overview-insights') || document.getElementById('overview');
  if (analysisContainer) {
    const existingAnalysis = analysisContainer.querySelector('[data-analysis="1"]');
    if (existingAnalysis) {
      existingAnalysis.innerHTML = analysisHTML;
    } else {
      const div = document.createElement('div');
      div.setAttribute('data-analysis', '1');
      div.innerHTML = analysisHTML;
      analysisContainer.appendChild(div);
    }
  }
