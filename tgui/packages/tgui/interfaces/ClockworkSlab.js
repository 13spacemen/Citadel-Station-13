import { map } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend, useSharedState } from '../backend';
import { Button, Flex, LabeledList, NoticeBox, Section, Tabs, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const ClockworkSlab = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    detail_view,
    disk,
    has_disk,
    has_program,
    scripture = {},
  } = data;
  const [
    selectedScripture,
    setSelectedScripture,
  ] = useSharedState(context, 'category');
  const scriptureInCategory = scripture
    && scripture[selectedScripture]
    || [];
  return (
    <Window resizable>
      <Window.Content theme="clockcult" scrollable>
        <Section
          title="Scripture Disk"
          buttons={(
            <AnimatedNumber
              value={data.power} />
          )}>
          {has_disk ? (
            has_program ? (
              <LabeledList>
                <LabeledList.Item label="Program Name">
                  {disk.name}
                </LabeledList.Item>
                <LabeledList.Item label="Description">
                  {disk.desc}
                </LabeledList.Item>
              </LabeledList>
            ) : (
              <NoticeBox>
                No Program Installed
              </NoticeBox>
            )
          ) : (
            <NoticeBox>
              Insert Disk
            </NoticeBox>
          )}
        </Section>
        <Section
          title="Programs"
          buttons={(
            <Fragment>
              <Button
                icon={detail_view ? 'info' : 'list'}
                content={detail_view ? 'Detailed' : 'Compact'}
                onClick={() => act('toggle_details')} />
              <Button
                icon="sync"
                content="Sync Research"
                onClick={() => act('refresh')} />
            </Fragment>
          )}>
          {scripture !== null ? (
            <Flex>
              <Flex.Item minWidth="110px">
                <Tabs vertical>
                  {map((cat_contents, category) => {
                    const progs = cat_contents || [];
                    // Backend was sending stupid data that would have been
                    // annoying to fix
                    const tabLabel = category
                      .substring(0, category.length - 8);
                    return (
                      <Tabs.Tab
                        key={category}
                        selected={category === selectedScripture}
                        onClick={() => setSelectedScripture(category)}>
                        {tabLabel}
                      </Tabs.Tab>
                    );
                  })(scripture)}
                </Tabs>
              </Flex.Item>
              <Flex.Item grow={1} basis={0}>
                {detail_view ? (
                  scriptureInCategory.map(program => (
                    <Section
                      key={program.id}
                      title={program.name}
                      level={2}
                      buttons={(
                        <Button
                          icon="download"
                          content="Download"
                          disabled={!has_disk}
                          onClick={() => act('download', {
                            program_id: program.id,
                          })} />
                      )}>
                      {program.desc}
                    </Section>
                  ))
                ) : (
                  <LabeledList>
                    {scriptureInCategory.map(program => (
                      <LabeledList.Item
                        key={program.id}
                        label={program.name}
                        buttons={(
                          <Button
                            icon="download"
                            content="Download"
                            disabled={!has_disk}
                            onClick={() => act('download', {
                              program_id: program.id,
                            })} />
                        )} />
                    ))}
                  </LabeledList>
                )}
              </Flex.Item>
            </Flex>
          ) : (
            <NoticeBox>
              No nanite scripture are currently researched.
            </NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
