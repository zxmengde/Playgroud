# BOE MEMS 压力传感课题前期研究边界与文献核查

日期：2026-04-23

类型：research

状态：active

## 研究目的

本条目用于支撑“去京东方前、在尚不知道企业具体工艺路线和产线数据的条件下，如何为 BOE MEMS 防水封装胶材工艺开发和 TGV MEMS 压力传感器良率预测课题做前期准备”的研究边界设定。

## 核心结论

当前阶段不应把总纲写成已经掌握 BOE 完整产品结构、封装牌号、工艺配方、测试规范和良率标签。更稳妥的表述是：以 BOE 公开专利和开放课题为依据，建立压阻式 MEMS 压力传感器的前期研究框架，重点形成可后续接入企业信息的结构模型、材料参数表、可靠性验证矩阵和数据字段体系。

BOE 专利 CN119803739A 明确公开了功能基板、背腔、压敏电阻、引线、接触电阻、绝缘层、通孔、电极层和 PEEK 封装层等结构要素。专利措辞为“封装层的材料包括聚醚醚酮”，因此 PEEK 可作为公开证据支持的优先候选材料，但不能写成企业唯一胶材对象。

“性能偏移低于 2%”“深硅刻蚀深度预测准确率 ≥80%”“芯片良率预测准确率 ≥70%”均来自 BOE 公开课题指标，但公开文本没有给出计算口径。当前阶段应设为“候选定义”，并在进入企业后以企业测试规范、量测方法和标签定义进行冻结。

## 建议的前期定义

1. 研究对象：压阻式 MEMS 压力传感器及其封装/玻璃基 TGV 平台约束。当前不承诺复现 BOE 真实产品，只建立前期可校准模型。
2. 胶材对象：PEEK 为专利公开的优先候选材料；同时保留 PI、环氧、硅胶、PTFE、Parylene 等材料作为文献对照或备选参数库。
3. 2% 性能偏移：前期建议定义为三次回流或 MSL 3 预处理前后，零点输出漂移、灵敏度漂移、桥路等效输出漂移或相对电阻漂移中的最大归一化变化。进入企业后由 BOE 的测试规范确定。
4. DRIE 深度预测准确率：前期不宜直接使用分类意义的 accuracy。建议记录 MAE、RMSE、MAPE、R2，并增加“落入企业工艺公差带的样本比例”。若企业坚持“准确率”，可定义为 `|预测深度-实测深度| <= 企业公差` 的比例。
5. 芯片良率预测准确率：前期可建立风险分类模型，但不能等同真实良率模型。进入企业后需明确标签是 die pass/fail、wafer 良率、批次良率、失效类型，或回流后漂移是否超限。若类别不平衡，应同时报告 precision、recall、F1、balanced accuracy、AUC 或 PR-AUC。

## 文献与来源

- BOE 专利：CN119803739A, MEMS压力传感器及其制作方法。Google Patents 显示申请人为 BOE Technology Group Co Ltd 等，公开日 2025-04-11；摘要和权利要求支持 PEEK 封装层、功能基板、背腔、压敏电阻、绝缘层通孔和电极层结构。URL: https://patents.google.com/patent/CN119803739A/zh
- Han, X. et al. “Advances in high-performance MEMS pressure sensors: design, fabrication, and packaging.” Microsystems & Nanoengineering, 2023. 该综述说明 MEMS 压力传感器包含压阻式、电容式、谐振式等机理，并指出压阻式传感器通常使用惠斯通电桥，同时讨论封装应力、TGV/TSV、无引线封装和高温介质兼容问题。URL: https://www.nature.com/articles/s41378-023-00620-1
- IPC/JEDEC J-STD-020E/F。标准用于非气密表面贴装器件的湿气/回流敏感等级分类，提供 MSL 与回流预处理框架。URL: https://webstore.ansi.org/standards/ipc/ipcjedecstd020e2015
- “Tuning high-temperature dielectric properties of poly ether ether ketone by using self-crosslinkable polyetherimide and nanoparticles.” Polymer Testing, 2022, DOI: 10.1016/j.polymertesting.2022.107858。说明 PEEK 具有作为高温聚合物介电材料的潜力，但高温介电稳定性仍需通过材料改性或实验评价。URL: https://www.sciencedirect.com/science/article/pii/S0142941822003798
- “Comparative evaluation of polymer encapsulation materials for high-temperature electronic devices.” Sensors and Actuators A: Physical, 2025, DOI: 10.1016/j.sna.2025.117130。比较 PU、PA、PTFE、PEEK、PI 等聚合物封装材料，支持“PEEK 是候选之一而非唯一对象”的处理方式。URL: https://www.sciencedirect.com/science/article/pii/S0924424725009367
- Li, Y. et al. “Application of Through Glass Via (TGV) Technology for Sensors Manufacturing and Packaging.” Sensors, 2024, 24, 171, DOI: 10.3390/s24010171。说明 TGV 适用于传感器制造与封装，玻璃基具有耐热、耐化学、高频电学和气密封装相关优势。URL: https://www.mdpi.com/1424-8220/24/1/171
- “Thermo-mechanical reliability of glass substrate and Through Glass Vias (TGV): A comprehensive review.” Microelectronics Reliability, 2024, DOI: 10.1016/j.microrel.2024.115477。综述玻璃基/TGV 的热机械可靠性、TGV 与玻璃间热应力、裂纹和填充均匀性等问题。URL: https://www.sciencedirect.com/science/article/pii/S0026271424001574
- Gerlt, M. S. et al. “Reduced Etch Lag and High Aspect Ratios by Deep Reactive Ion Etching (DRIE).” Micromachines, 2021, 12(5), 542, DOI: 10.3390/mi12050542。说明 DRIE 中刻蚀滞后、高深宽比、侧壁角、刻蚀深度和工艺参数优化是 MEMS 深硅刻蚀的重要问题。URL: https://www.mdpi.com/2072-666X/12/5/542
- Harju, J. “Prediction of deep reactive ion etch profile variations in MEMS devices.” Aalto University, 2025。提出基于几何上下文与晶圆尺度效应的 DRIE profile variation 数据驱动预测，可作为前期良率模型的数据结构参考。URL: https://aaltodoc.aalto.fi/items/34cb6105-8c63-41c0-bc76-75807114a790
- Lee, Y. and Roh, Y. “An Expandable Yield Prediction Framework Using Explainable Artificial Intelligence for Semiconductor Manufacturing.” Applied Sciences, 2023, 13(4), 2660, DOI: 10.3390/app13042660。提出多类型制造数据输入、模型比较与 SHAP 解释的半导体良率预测框架。URL: https://www.mdpi.com/2076-3417/13/4/2660
- Podder, I. et al. “Artificial Intelligence Applications for MEMS-Based Sensors and Manufacturing Process Optimization.” Eng, 2023, 4(1), 11。综述 AI 在 MEMS 传感器和制造过程优化中的应用。URL: https://www.mdpi.com/2673-4001/4/1/11
- Saito, T. and Rehmsmeier, M. “The Precision-Recall Plot Is More Informative than the ROC Plot When Evaluating Binary Classifiers on Imbalanced Datasets.” PLOS ONE, 2015, DOI: 10.1371/journal.pone.0118432。支持良率/失效样本类别不平衡时，不应只报告普通 accuracy。URL: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0118432

## 后续可执行事项

1. 将总纲中“唯一主研究对象”改为“前期主研究对象”，避免暗示已掌握企业真实路线。
2. 将 PEEK 改为“专利公开优先候选材料”，并新增“候选胶材参数库”。
3. 将三个企业指标分别改为“公开指标 + 前期候选计算口径 + 企业确认后冻结口径”。
4. 将 TGV 相关表述分成两类：玻璃基/TGV 平台互连约束，和专利功能基板内绝缘层通孔/接触通孔，避免混同。
5. 在进入企业前优先完成文献参数库、标准化实验矩阵、仿真模板、数据字段表和模型卡模板，而不是等待企业数据后才开始研究。
